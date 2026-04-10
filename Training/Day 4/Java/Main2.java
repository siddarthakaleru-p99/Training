abstract class Shape {
    String colour;
    Shape(String colour) {
        this.colour = colour;
    }
    abstract double calculateArea();
}
class Circle extends Shape {
    double radius;

    Circle(String colour, double radius) {
        super(colour);
        this.radius = radius;
    }

    double calculateArea() {
        return Math.PI * radius * radius;
    }
}
class Rectangle extends Shape {
    double length;
    double width;

    Rectangle(String colour, double length, double width) {
        super(colour);
        this.length = length;
        this.width = width;
    }

    double calculateArea() {
        return length * width;
    }
}
class Square extends Shape {
    double side;

    Square(String colour, double side) {
        super(colour);
        this.side = side;
    }

    double calculateArea() {
        return side * side;
    }
}
public class Main2 {
    public static void main(String[] args) {

        Shape circle = new Circle("Red", 5);
        Shape rectangle = new Rectangle("Blue", 4, 6);
        Shape square = new Square("Green", 3);

        System.out.println("Circle Area: " + circle.calculateArea());
        System.out.println("Rectangle Area: " + rectangle.calculateArea());
        System.out.println("Square Area: " + square.calculateArea());
    }
}