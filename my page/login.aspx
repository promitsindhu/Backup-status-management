<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Backup_status_management.my_page.login" %>

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
            $scope.myfun = function () {
                if ($scope.password != $scope.cpassword) {
                    $("#password").css("border-color", "red");
                    $("#cpassword").css("border-color", "red");
                }
                else {
                    $("#password").css("border-color", "green");
                    $("#cpassword").css("border-color", "green");
                }
            }
            $scope.login = function () {
                debugger;
                if ($scope.email.length > 0 && $scope.password.length > 0 && $scope.cpassword.length > 0) {
                    if ($scope.password != $scope.cpassword) {
                        $scope.incorrect = true;
                        alert("Password and Confirm Password is incorrect");
                    }
                    else {
                        debugger;
                        $http({
                            method: "POST",
                            url: "../web%20services/clientdash.asmx/checklogindetails",
                            data: { "username": $scope.email, "password": $scope.password },
                            datatype: 'json'
                        }).then(function (response) {
                            debugger;
                            $scope.value = response;

                            var obj = new Object();
                            obj = response.data.d
                            if (obj.IsSaved == false) {
                                alert("Enter valid Email");
                            }
                            else if (obj.IsSaved == true) {
                                window.open("frmbackupclients.aspx", "_self");

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
            }

            $scope.register = function () {
                window.open("register.aspx", "_self");
            }
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div data-ng-app="myApp" data-ng-controller="myCtrl" id="MyBody">
            <div class="login-container">
        <h2>Login</h2>
             <div class="form-group">
                <label for="username">Email:</label>
                <input type="email" id="username" name="username" data-ng-model="email" required="required"/>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" data-ng-model="password"  required="required"/>
            </div>
                <div class="form-group">
                <label for="password">Confirm Password:</label>
                <input type="password" id="cpassword" name="password" data-ng-change="myfun()" data-ng-model="cpassword"  required="required"/>
                    <span data-ng-show="incorrect" style="color:red; text-align:right">Enter Correct Password</span>
            </div>
                
             <button type="button" data-ng-click="login()">Login</button>
                <span>Don't have an account?<a class="backbutton" data-ng-click="register()" style=" text-decoration: none;" > Register</a></span>
                </div>
            
        </div>
    </form>
</body>
</html>
