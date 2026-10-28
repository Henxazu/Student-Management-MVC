<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Detail</title>
</head>

<body>
    <h1>Student Detail</h1>

    <p>ID: ${student.id}</p>
    <p>Student Code: ${student.studentCode}</p>
    <p>Full Name: ${student.fullName}</p>
    <p>Email: ${student.email}</p>
    <p>Major: ${student.major}</p>

    <a href="student?action=list">Back to List</a>
    <a href="student?action=edit&id=${student.id}">Edit</a>
    <a href="student?action=confirmDelete&id=${student.id}">Delete</a>
</body>

</html>