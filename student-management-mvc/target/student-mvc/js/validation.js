/**
 * Client-side validation for Student Form
 */
function initValidation() {
    const studentCode = document.getElementById("student_code");
    const fullName = document.getElementById("full_name");
    const email = document.getElementById("email");
    const major = document.getElementById("major");
    const form = document.getElementById("student-form");

    if (!form) return;

    function setFieldError(field, errorSpanId, message) {
        const errorSpan = document.getElementById(errorSpanId);
        if (message) {
            field.classList.add("is-invalid");
            if (errorSpan) errorSpan.textContent = message;
            return false;
        } else {
            field.classList.remove("is-invalid");
            if (errorSpan) errorSpan.textContent = "";
            return true;
        }
    }

    function validStudentCode() {
        if (!studentCode) return true;
        // Auto trim and uppercase for better UX
        studentCode.value = studentCode.value.trim().toUpperCase();
        const val = studentCode.value;
        if (val === "") {
            return setFieldError(studentCode, "errorStudentCode", "Student code is required");
        } else if (!/^[A-Z]{2,6}\d{5}$/.test(val)) {
            return setFieldError(studentCode, "errorStudentCode", "Must be 2-6 letters followed by 5 digits (e.g. SV00001, CS10001)");
        } else {
            return setFieldError(studentCode, "errorStudentCode", "");
        }
    }

    function validFullName() {
        if (!fullName) return true;
        const val = fullName.value.trim();
        if (val === "") {
            return setFieldError(fullName, "errorFullName", "Full name is required");
        } else if (val.length < 2) {
            return setFieldError(fullName, "errorFullName", "Full name must be at least 2 characters");
        } else if (val.length > 50) {
            return setFieldError(fullName, "errorFullName", "Full name cannot exceed 50 characters");
        } else {
            return setFieldError(fullName, "errorFullName", "");
        }
    }

    function validEmail() {
        if (!email) return true;
        const val = email.value.trim();
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (val === "") {
            return setFieldError(email, "errorEmail", "Email address is required");
        } else if (!emailRegex.test(val)) {
            return setFieldError(email, "errorEmail", "Please enter a valid email address (e.g. user@example.com)");
        } else {
            return setFieldError(email, "errorEmail", "");
        }
    }

    function validMajor() {
        if (!major) return true;
        const val = major.value;
        if (val === "" || val === null) {
            return setFieldError(major, "errorMajor", "Please select a major");
        } else {
            return setFieldError(major, "errorMajor", "");
        }
    }

    // Live validation on blur and input
    if (studentCode) {
        studentCode.addEventListener("blur", validStudentCode);
        studentCode.addEventListener("input", function() {
            if (studentCode.classList.contains("is-invalid")) validStudentCode();
        });
    }

    if (fullName) {
        fullName.addEventListener("blur", validFullName);
        fullName.addEventListener("input", function() {
            if (fullName.classList.contains("is-invalid")) validFullName();
        });
    }

    if (email) {
        email.addEventListener("blur", validEmail);
        email.addEventListener("input", function() {
            if (email.classList.contains("is-invalid")) validEmail();
        });
    }

    if (major) {
        major.addEventListener("change", validMajor);
    }

    // Form submit guard
    form.addEventListener("submit", function(event) {
        const isCodeValid = validStudentCode();
        const isNameValid = validFullName();
        const isEmailValid = validEmail();
        const isMajorValid = validMajor();

        if (!isCodeValid || !isNameValid || !isEmailValid || !isMajorValid) {
            event.preventDefault();
            // Focus on first invalid input
            const firstInvalid = form.querySelector(".is-invalid");
            if (firstInvalid) {
                firstInvalid.focus();
            }
        }
    });
}

document.addEventListener("DOMContentLoaded", initValidation);
