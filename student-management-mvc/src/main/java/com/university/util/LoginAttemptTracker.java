package com.university.util;

import java.util.concurrent.ConcurrentHashMap;

public class LoginAttemptTracker {

    private static final int MAX_ATTEMPTS = 5;
    private static final long LOCK_WINDOW_MS = 15 * 60 * 1000L; // 15 phút

    private static class AttemptInfo {
        int count;
        long firstAttemptTime;

        AttemptInfo(int count, long firstAttemptTime) {
            this.count = count;
            this.firstAttemptTime = firstAttemptTime;
        }
    }

    private static final ConcurrentHashMap<String, AttemptInfo> attempts = new ConcurrentHashMap<>();

    private static String normalize(String username) {
        return username == null ? "" : username.trim().toLowerCase();
    }

    public static boolean isBlocked(String username) {
        String key = normalize(username);
        AttemptInfo info = attempts.get(key);
        if (info == null) {
            return false;
        }

        long now = System.currentTimeMillis();
        synchronized (info) {
            if (now - info.firstAttemptTime > LOCK_WINDOW_MS) {
                attempts.remove(key, info);
                return false;
            }
            return info.count >= MAX_ATTEMPTS;
        }
    }

    public static void recordFailure(String username) {
        String key = normalize(username);
        long now = System.currentTimeMillis();

        attempts.compute(key, (k, info) -> {
            if (info == null || (now - info.firstAttemptTime > LOCK_WINDOW_MS)) {
                return new AttemptInfo(1, now);
            }
            synchronized (info) {
                info.count++;
                return info;
            }
        });
    }

    public static void reset(String username) {
        attempts.remove(normalize(username));
    }
}