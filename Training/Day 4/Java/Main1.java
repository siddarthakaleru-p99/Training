class Animal {
    String name;

    public void eat() {
        System.out.println("This animal eats food.");
    }

    public void display_name() {
        if (name==null){
            System.out.println("No name is Assigned");
        }
        else System.out.println("Name: " + name);
    }
}

class Dog extends Animal {
    public void bark() {
        System.out.println("The dog barks: Woof! Woof!");
    }
}

class Husky extends Dog {
    public void color() {
        System.out.println("Husky color is White");
    }
}

public class Main1 {
    public static void main(String[] args) {
        Husky myDog = new Husky();

        myDog.name = "Buddy";
        myDog.eat();

        myDog.bark();

        myDog.display_name();

        myDog.color();
    }
}
