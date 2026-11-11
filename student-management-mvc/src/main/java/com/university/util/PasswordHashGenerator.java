package com.university.util;

import org.mindrot.jbcrypt.BCrypt;
public class PasswordHashGenerator {
    public static void main(String[] args) {
        String plain = "passsword002";
        String hash = BCrypt.hashpw(plain, BCrypt.gensalt());
        System.out.println("Hash: " + hash);
        System.out.println("Verify: " + BCrypt.checkpw(plain, hash));
    }
}
