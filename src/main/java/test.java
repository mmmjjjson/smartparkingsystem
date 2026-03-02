import org.mindrot.jbcrypt.BCrypt;

import java.util.UUID;

public class test {
    public static void main(String[] args) {
        String uuid = UUID.randomUUID().toString();
        System.out.println(uuid);
        System.out.println(uuid.length());

        String ps = "demo1234";
        System.out.println(BCrypt.hashpw(ps, BCrypt.gensalt(12)));
    }
}
