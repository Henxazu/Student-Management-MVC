const studentCode = document.getElementById("student_code");
const fullName = document.getElementById("full_name");
const email = document.getElementById("email");
const major = document.getElementById("major");

function validStudentCode() {
    if (studentCode.value === "") {
        document.getElementById("errorStudentCode").textContent = "Student code is required";
        return false;
    }
    else if (!/^[A-Z]{2,6}\d{5}$/.test(studentCode.value)) {
        document.getElementById("errorStudentCode").textContent = "Invalid student code";
        return false;
    } else {
        document.getElementById("errorStudentCode").textContent = "";
        return true;
    }
}

function validFullName() {
    if (fullName.value === "") {
        document.getElementById("errorFullName").textContent = "Full name is required";
        return false;
    }
    else if (fullName.value.length > 50) {
        document.getElementById("errorFullName").textContent = "Full name is too long";
        return false;
    } else {
        document.getElementById("errorFullName").textContent = "";
        return true;
    }
}

function validEmail() {
    if (email.value === "") {
        document.getElementById("errorEmail").textContent = "Email is required";
        return false;
    }
    else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)) {
        document.getElementById("errorEmail").textContent = "Invalid email";
        return false;
    } else {
        document.getElementById("errorEmail").textContent = "";
        return true;
    }
}

function validMajor() {
    if (major.value === "") {
        document.getElementById("errorMajor").textContent = "Major is required";
        return false;
    }
    else if (major.value.length > 50) {
        document.getElementById("errorMajor").textContent = "Major is too long";
        return false;
    } else {
        document.getElementById("errorMajor").textContent = "";
        return true;
    }
}

function init() {
    document.getElementById("student_code").addEventListener("blur", validStudentCode);
    document.getElementById("full_name").addEventListener("blur", validFullName);
    document.getElementById("email").addEventListener("blur", validEmail);
    document.getElementById("major").addEventListener("blur", validMajor);

    document.getElementById("student-form").addEventListener("submit", function (event) {
        if (!validStudentCode() || !validFullName() || !validEmail() || !validMajor()) {
            event.preventDefault();
        }
    });
}

window.addEventListener("load", init);