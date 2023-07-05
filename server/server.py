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

    def __init__(self, name, image, price, description, type):
        self.name = name
        self.image = image
        self.price = price
        self.description = description
        self.type = type


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
        "password": "****"
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
        "password": "****"
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
    #                 description="This is a beautiful orange sweater.", type="Clothing"),
    #         Product(name="Red wine sweater", image="sweater2.jpg", price=89,
    #                 description="Stay cozy with this red wine-colored sweater.", type="Clothing"),
    #         Product(name="Sand sweater", image="sweater3.jpg", price=79,
    #                 description="Elevate your style with this trendy sand-colored sweater.", type="Clothing"),
    #         Product(name="Sea sweater", image="sweater4.jpg", price=94,
    #                 description="Get a refreshing look with this sea-inspired sweater.", type="Clothing"),
    #         Product(name="Cream sweater", image="sweater5.jpg", price=99,
    #                 description="Wrap yourself in luxury with this cream-colored sweater.", type="Clothing"),
    #         Product(name="Beige sweater", image="sweater6.jpg", price=65,
    #                 description="A versatile beige sweater for any occasion.", type="Clothing"),
    #         Product(name="Grey sweater", image="sweater7.jpg", price=54,
    #                 description="Stay chic and cozy with this stylish grey sweater.", type="Clothing"),
    #         Product(name="Mink sweater", image="sweater8.jpg", price=83,
    #                 description="Experience comfort and elegance with this mink-colored sweater.", type="Clothing")
    #     ]
    #
    #     db.session.bulk_save_objects(productList)
    #     db.session.commit()
