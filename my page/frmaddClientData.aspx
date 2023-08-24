<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmaddClientData.aspx.cs" Inherits="Backup_status_management.my_page.frmaddClientData" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Backup</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css"/>
    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    

    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
    <style>
        .backbutton:hover {
            /*color:#2F2F2F;*/
            border-radius: 50px;
            background-color: #2F2F2F;
            color:white;
        }
        .btn{
            background-color: #2F2F2F;
            color:white;
        }
        .btn:hover{
            background:white;
            color:#2F2F2F;
            border-color:#2F2F2F;
        }
        .card {
            box-shadow: rgba(0, 0, 0, 0.16) 0px 1px 4px;
            padding-right: 10px;
            padding-left: 10px;
            padding-top: 10px;
            padding-bottom: 10px;
        }
        .name{
            font-size:14px;
        }
        .navbar{
            background-color:whitesmoke;
            border-color:whitesmoke;
        }
        .navbar-brand{
            
            font-size:x-large;
        }
        .navbar-brand:hover{
            border-radius: 50px;
            background-color: #2F2F2F;
            color:white;
        }
        .backbutton{
            color:#2F2F2F;
        }
        body{
            background-color:whitesmoke;
        }
        .card{
            background-color:white;
        }
    </style>

    <script>
        function getQueryString(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, "\\$&");
            var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, " "));
        }
        var app = angular.module('myApp', []);
        app.controller('myCtrl', function ($scope, $http) {
            $scope.disabled = false;
            $scope.obj = new Object();
            $scope.code = getQueryString("Code", window.location.href);

            $scope.Back = function () {
                window.history.back();
            }
            if ($scope.code != null) {
                debugger;
                $http({
                    method: "POST",
                    url: "../web%20services/clientdash.asmx/getClientData",
                    data: { "cc": $scope.code },
                    datatype: 'json'
                }).then(function (response) {
                    console.log(response.data.d);

                    $scope.disabled = true;
                    $scope.obj = response.data.d;



                });
            }
            $scope.saveClient = function () {
                debugger;
                $http({
                    method: "POST",
                    url: "../web%20services/clientdash.asmx/saveClientData",
                    data: { "obj": $scope.obj},
                    datatype: 'json'

                }).then(function (response) {
                    debugger
                    $scope.value = response;

                    var obj = new Object();
                    obj = response.data.d
                    if (obj.IsSaved == false) {
                        alert(obj.ErrorMsg);
                    }
                    else if (obj.IsSaved == true) {
                        alert(obj.SuccessMsg);
                        window.open("frmaddClientData.aspx", "_self");
                    }

                }).catch(function (response) {
                    debugger
                    var obj = new Object();
                    obj = response.data.Message;
                    alert(obj);
                    console.log(response.data);
                });
            }
            $scope.deleteClient = function () {
                $http({
                    method: "POST",
                    url: "../web%20services/clientdash.asmx/deleteClientData",
                    data: { "obj": $scope.obj },
                    datatype: 'json'

                }).then(function (response) {
                    debugger
                    $scope.value = response;

                    var obj = new Object();
                    obj = response.data.d
                    if (obj.IsSaved == false) {
                        alert(obj.ErrorMsg);
                    }
                    else if (obj.IsSaved == true) {
                        alert(obj.SuccessMsg);
                        window.open("frmaddClientData.aspx", "_self");
                        
                    }

                }).catch(function (response) {
                    debugger
                    var obj = new Object();
                    obj = response.data.Message;
                    alert(obj);
                    console.log(response.data);
                });
            }

            $scope.logout = function () {
                window.open("frmbackupclients.aspx", "_self");
            }
           
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div data-ng-app="myApp" data-ng-controller="myCtrl" id="MyBody">
            <div class="container-fluid" style="padding-left:0px; padding-right:0px;">
                <nav class="navbar navbar-inverse card " style="margin-bottom: 0px;padding-top:5px;padding-bottom:5px;">
                    <div class="container-fluid" style="padding-left:0px;padding-right:0px;">
                        <div class="navbar-header" style="margin-left: 0px; margin-right: 0px; width: 100%;">
                            <div class="inline">
                                <div class="pull-left">
                                    <a class="navbar-brand " style="color:#2F2F2F" href="#">Client</a>
                                </div>
                                <div class="pull-right">
                                    <a class="backbutton" style="display: block; text-align: center; padding: 10px 12px; margin-top: 0px; text-decoration: none; font-size: medium;" data-ng-click="logout()"><span class="glyphicon glyphicon-log-out"></span> Home Page</a>
                                </div>
                                <%--<div class="pull-right">
                                    <a class="backbutton" style=" display: block; text-align: center; padding: 14px 16px; margin-top: 0px; text-decoration: none; font-size:larger;" data-ng-click="Back()"><span class="glyphicon glyphicon-chevron-left"></span> Back</a>
                                </div>--%>
                            </div>
                        </div>

                    </div>
                </nav>
                <hr style="color:black;margin-top:5px;margin-bottom:15px;"/>

                <div class="col-lg-3 col-md-3"></div>
                
                    <div class="col-lg-6 col-md-6 col-sm-12">
                        <div class="">
                        <label class="name">Code</label>
                        <input class="form-control " data-ng-disabled="disabled" type="text" data-ng-model="obj.code" />
                        <br />
                        <label class="name">Client Name</label>
                        <input class="form-control " type="text" data-ng-model="obj.name" />
                        <br />
                        <label class="name">Connection String</label>
                        <input class="form-control " type="text" data-ng-model="obj.connection_string" />
                        <br />
                            <label>ID</label>
                            <input class="form-control " type="text" data-ng-model="obj.id"/>
                            <br />
                            <label>Password</label>
                            <input class="form-control " type="password" data-ng-model="obj.password"/>
                            <br />
                        <label class="name">Ap Database Name</label>
                        <input class="form-control " type="text" data-ng-model="obj.ap_db_name" />
                        <br />
                        <label class="name">Ap Lab Database Name</label>
                        <input class="form-control i" type="text" data-ng-model="obj.aplab_db_name" />
                        <br />
                        <label class="name">Pharmacy Database Name</label>
                        <input class="form-control " type="text" data-ng-model="obj.pharmacy_db_name" />
                        <br />
                            <div class="row" style="margin-left:0px; margin-right:0px;">
                        <button class="col-lg-6 col-md-6 col-sm-6 btn  " data-ng-click="deleteClient()" style="border-radius:20px;">Delete</button>
                        <button class="col-lg-6 col-md-6 col-sm-6 btn " data-ng-click="saveClient()" style="border-radius:20px;">Save</button>
                    </div>
                            </div>
                         </div>
                </div>
                <div class="col-lg-3 col-md-3"></div>
           
        </div>
    </form>
</body>
</html>
