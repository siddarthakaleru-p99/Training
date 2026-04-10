import java.util.*;
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
        int n=10;
        Main obj=new Main();
        obj.number(n);
    }
    int number(int n){
        System.out.println(n*10);
        return n;
    }
}