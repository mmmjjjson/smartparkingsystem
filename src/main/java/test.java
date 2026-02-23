import org.mindrot.jbcrypt.BCrypt;

public class test {
    public static void main(String[] args) {
        String s = "demo1234";
        System.out.println(BCrypt.hashpw(s, BCrypt.gensalt(12)));
    }
}
