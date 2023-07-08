import os

from flask import Flask, jsonify, request, send_from_directory
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///products.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Set the path to the images directory
IMAGES_DIR = os.path.join(app.root_path, 'images')

db = SQLAlchemy(app)


class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    image = db.Column(db.String(100))
    price = db.Column(db.Float)
    description = db.Column(db.String(200))
    type = db.Column(db.String(50))
    comments = db.relationship('Comment', backref='product', lazy=True)
    ratings = db.Column(db.JSON)  # Dictionary of user ratings
    number_of_ratings = db.Column(db.Integer, default=0)  # Number of ratings

    def __init__(self, name, image, price, description, type, ratings=None):
        self.name = name
        self.image = image
        self.price = price
        self.description = description
        self.type = type
        self.ratings = ratings or {}  # Initialize with an empty dictionary if ratings is not provided
        self.number_of_ratings = len(self.ratings)

    def add_rating(self, user_id, rating):
        self.ratings[str(user_id)] = rating
        self.number_of_ratings = len(self.ratings)
        self.calculate_average_rating()

    def calculate_average_rating(self):
        total_rating = sum(self.ratings.values())
        self.rating = total_rating / self.number_of_ratings if self.number_of_ratings > 0 else 0.0


class Comment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(100), nullable=False)
    text = db.Column(db.String(200), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)

    def __init__(self, username, text, product_id):
        self.username = username
        self.text = text
        self.product_id = product_id


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(100), unique=True, nullable=False)
    password = db.Column(db.String(100), nullable=False)
    first_name = db.Column(db.String(100))
    last_name = db.Column(db.String(100))

    def __init__(self, email, password, first_name, last_name):
        self.email = email
        self.password = password
        self.first_name = first_name
        self.last_name = last_name


@app.route("/products", methods=["GET"])
def get_products():
    products = Product.query.all()
    product_list = []

    for product in products:
        product_dict = {
            "id": product.id,
            "name": product.name,
            "image": product.image,
            "price": product.price,
            "description": product.description,
            "type": product.type
        }
        product_list.append(product_dict)

    return jsonify(product_list)


@app.route("/product/<int:product_id>/comment", methods=["POST"])
def add_comment(product_id):
    data = request.json
    username = data.get("username")
    text = data.get("text")

    if not username or not text:
        return jsonify({"error": "Username and text are required."}), 400

    product = Product.query.get(product_id)
    if not product:
        return jsonify({"error": "Product not found."}), 404

    comment = Comment(username=username, text=text, product_id=product_id)
    db.session.add(comment)
    db.session.commit()

    return jsonify({"message": "Comment added successfully."}), 201


@app.route("/product/<int:product_id>/rating", methods=["POST"])
def add_rating(product_id):
    data = request.json
    user_id = data.get("user_id")
    rating = data.get("rating")

    if not user_id or not rating:
        return jsonify({"error": "User ID and rating are required."}), 400

    try:
        rating = float(rating)
        if rating < 0 or rating > 5:
            return jsonify({"error": "Rating should be between 0 and 5."}), 400
    except ValueError:
        return jsonify({"error": "Invalid rating value."}), 400

    product = Product.query.get(product_id)
    if not product:
        return jsonify({"error": "Product not found."}), 404

    if user_id in product.ratings:
        return jsonify({"error": "User has already rated this product."}), 400

    product.add_rating(user_id, rating)
    db.session.commit()

    return jsonify({"message": "Rating added successfully."}), 201


@app.route("/product/image", methods=["GET"])
def get_product_image():
    product_name = request.args.get("productName")
    product = Product.query.filter_by(name=product_name).first()

    if product:
        image_filename = product.image
        image_path = os.path.join(IMAGES_DIR, image_filename)
        return send_from_directory(IMAGES_DIR, image_filename)
    else:
        return jsonify({"error": "Product not found."})


@app.route("/user/<string:email>", methods=["PUT"])
def update_user(email):
    data = request.json

    user = User.query.filter_by(email=email).first()
    if not user:
        return jsonify({"error": "User not found."}), 404

    # Update the user attributes
    if "password" in data:
        user.password = data["password"]
    if "first_name" in data:
        user.first_name = data["first_name"]
    if "last_name" in data:
        user.last_name = data["last_name"]

    db.session.commit()

    # Return the updated user object
    user_object = {
        "email": user.email,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "password" : user.password
    }

    return jsonify(user_object), 200



@app.route("/signup", methods=["POST"])
def signup():
    data = request.json
    email = data.get("email")
    password = data.get("password")
    first_name = data.get("first_name")
    last_name = data.get("last_name")

    if not email or not password:
        return jsonify({"error": "Email and password are required."}), 400

    existing_user = User.query.filter_by(email=email).first()
    if existing_user:
        return jsonify({"error": "User with this email already exists."}), 400

    new_user = User(email=email, password=password, first_name=first_name, last_name=last_name)
    db.session.add(new_user)
    db.session.commit()

    user_object = {
        "email": new_user.email,
        "first_name": new_user.first_name,
        "last_name": new_user.last_name,
        "password": new_user.password,
    }

    return jsonify(user_object), 201


@app.route("/login", methods=["POST"])
def login():
    data = request.json
    email = data.get("email")
    password = data.get("password")

    if not email or not password:
        return jsonify({"error": "Email and password are required."}), 400

    user = User.query.filter_by(email=email).first()
    if not user or user.password != password:
        return jsonify({"error": "Invalid email or password."}), 401

    user_object = {
        "email": user.email,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "password": user.password
    }

    return jsonify(user_object), 200


if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(port=9000)

    # with app.app_context():
    #     db.create_all()
    #
    #     productList = [
    #         Product(name="Orange sweater", image="sweater1.jpg", price=54,
    #                 description="This is a beautiful orange sweater.", type="Sweater"),
    #         Product(name="Red wine sweater", image="sweater2.jpg", price=89,
    #                 description="Stay cozy with this red wine-colored sweater.", type="Sweater"),
    #         Product(name="Sand sweater", image="sweater3.jpg", price=79,
    #                 description="Elevate your style with this trendy sand-colored sweater.", type="Sweater"),
    #         Product(name="Sea sweater", image="sweater4.jpg", price=94,
    #                 description="Get a refreshing look with this sea-inspired sweater.", type="Sweater"),
    #         Product(name="Cream sweater", image="sweater5.jpg", price=99,
    #                 description="Wrap yourself in luxury with this cream-colored sweater.", type="Sweater"),
    #         Product(name="Beige sweater", image="sweater6.jpg", price=65,
    #                 description="A versatile beige sweater for any occasion.", type="Sweater"),
    #         Product(name="Grey sweater", image="sweater7.jpg", price=54,
    #                 description="Stay chic and cozy with this stylish grey sweater.", type="Sweater"),
    #         Product(name="Mink sweater", image="sweater8.jpg", price=83,
    #                 description="Experience comfort and elegance with this mink-colored sweater.", type="Sweater"),
    #         Product(name="Mink sweater", image="sweater8.jpg", price=83,
    #                 description="Experience comfort and elegance with this mink-colored sweater.", type="Sweater"),
    #         Product(name="Hoodie 1", image="hoodie1.jpeg", price=59,
    #                 description="Stay warm and trendy with this stylish hoodie.", type="Hoodie"),
    #         Product(name="Hoodie 2", image="hoodie2.jpeg", price=64,
    #                 description="Add a pop of color to your wardrobe with this vibrant hoodie.", type="Hoodie"),
    #         Product(name="Hoodie 3", image="hoodie3.jpeg", price=72,
    #                 description="Upgrade your street wear collection with this cool hoodie.", type="Hoodie"),
    #         Product(name="Hoodie 4", image="hoodie4.jpeg", price=68,
    #                 description="Stay comfortable and cozy with this classic hoodie.", type="Hoodie"),
    #         Product(name="Hoodie 5", image="hoodie5.jpeg", price=77,
    #                 description="Elevate your casual look with this fashionable hoodie.", type="Hoodie"),
    #         Product(name="Pants 1", image="pants1.jpeg", price=69,
    #                 description="Stay comfortable and stylish with these versatile pants.", type="Pants"),
    #         Product(name="Pants 2", image="pants2.jpeg", price=79,
    #                 description="Upgrade your wardrobe with these trendy pants.", type="Pants"),
    #         Product(name="Pants 3", image="pants3.jpeg", price=62,
    #                 description="Get a sleek and modern look with these slim-fit pants.", type="Pants"),
    #         Product(name="Pants 4", image="pants4.jpeg", price=75,
    #                 description="Stay chic and confident with these fashionable pants.", type="Pants")
    #     ]
    #
    #     db.session.bulk_save_objects(productList)
    #     db.session.commit()
    #
    #     app.run(port=9000)
