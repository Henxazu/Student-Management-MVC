package com.university.util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CookieUtil {

    /**
     * Create or replace a cookie with the given name and value. Sets HttpOnly
     * to prevent JavaScript access. Does not set Secure (enable in production
     * with HTTPS).
     */
    public static void set(HttpServletResponse response,
            String name, String value, int maxAgeSeconds) {
        Cookie cookie = new Cookie(name, value);
        cookie.setMaxAge(maxAgeSeconds);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        // cookie.setSecure(true); // uncomment in production
        response.addCookie(cookie);
    }

    /**
     * Return the value of the named cookie, or null if it does not exist.
     */
    public static String get(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (name.equals(c.getName())) {
                    return c.getValue();
                }
            }
        }
        return null;
    }

    /**
     * Return true if the named cookie exists.
     */
    public static boolean has(HttpServletRequest request, String name) {
        return get(request, name) != null;
    }

    /**
     * Delete a cookie by setting its MaxAge to 0. The path must match the path
     * used when the cookie was created.
     */
    public static void delete(HttpServletResponse response, String name) {
        Cookie cookie = new Cookie(name, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }
}