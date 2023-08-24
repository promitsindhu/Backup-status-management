    <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="Backup_status_management.my_page.register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css"/>
    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>

	<style>
        /* Add your CSS styles here */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-container {
            display:grid;
            background-color: #fff;
            border: 1px solid #ccc;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            width: 500px;
        }
        h2 {
            text-align: center;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            font-weight: bold;
            display: block;
        }
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }
        button {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 3px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .backbutton{
            
            cursor:pointer;
        }
        span{
            margin-top:10px;
            text-align:center;
        }
        </style>
    <script>
        var app = angular.module('myApp', []);
        app.controller('myCtrl', function ($scope, $http) {
            $scope.logout = function () {
                window.open("login.aspx","_self");
            }
            $scope.login = function () {
                debugger;
                if ($scope.email.length > 0 && $scope.password.length > 0) {
                    $http({
                        method: "POST",
                        url: "../web%20services/clientdash.asmx/savelogindetails",
                        data: { "username": $scope.email, "password": $scope.password },
                        datatype: 'json'
                    }).then(function (response) {
                        debugger;
                        $scope.value = response;

                        var obj = new Object();
                        obj = response.data.d
                        if (obj.IsSaved == false) {
                            alert(obj.ErrorMsg);
                        }
                        else if (obj.IsSaved == true) {
                            alert(obj.SuccessMsg);
                            window.open("login.aspx", "_self");

                        }

                    }).catch(function (response) {
                        debugger
                        var obj = new Object();
                        obj = response.data.Message;
                        alert(obj);
                        console.log(response.data);
                    });
                }
            }

            

        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div data-ng-app="myApp" data-ng-controller="myCtrl" id="MyBody">
            
            <div class="login-container">
        <h2>Register</h2>
             <div class="form-group">
                <label >Email:</label>
                <input type="email" data-ng-model="email" required="required"/>
            </div>
            <div class="form-group">
                <label >Password:</label>
                <input type="password" data-ng-model="password"  required="required"/>
            </div>
             <button type="submit" data-ng-click="login()">Register</button>
                <span>Already have an account?<a class="backbutton" data-ng-click="logout()" style=" text-decoration: none;" > LogIn</a></span>
                </div>
        </div>
    </form>
</body>
</html>