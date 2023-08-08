<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmbackupclients.aspx.cs" Inherits="ClientDashBoard.MainMenu.frmbackupclients" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Backup</title>
    <script src="../Scripts/bootstrap.js"></script>
    <script src="../Scripts/jquery-3.4.1.min.js"></script>
    <link href="../Content/bootstrap.min.css" rel="stylesheet" />

    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>

    <style>
        .backbutton:hover {
            /*color:#2F2F2F;*/
            border-radius: 50px;
            background-color: #2F2F2F;
        }
        .btn:hover{
            background-color: #2F2F2F;
        }
        .card {
            box-shadow: rgba(0, 0, 0, 0.16) 0px 1px 4px;
            padding-right: 10px;
            padding-left: 10px;
            padding-top: 10px;
            padding-bottom: 10px;
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
        th,td
        {
            text-align:center;
        }
    </style>

    <script>
        var app = angular.module('myApp', []);
        app.controller('myCtrl', function ($scope, $http) {
            $scope.arr = [];
            $scope.Back = function () {
                window.history.back();
            }
            $scope.openClientdetails = function () {
                window.open("frmaddClientData.aspx") 

            }
            $scope.logout = function () {
                window.open("mainpage.aspx", "_self");
            }
            $http({
                method: "POST",
                url: "../WebServices/clientdash.asmx/getClients",
                data: { },
                datatype: 'json'
            }).then(function (response) {
                console.log(response.data.d);
                $scope.arr = response.data.d;

            });
            $scope.openClient = function (code) {
                window.open("frmaddClientData.aspx?Code=" + code);
            }
            $scope.openbackups = function () {
                window.open("frmbackupstaus.aspx");
            }
            $scope.mailbackupstatus = function () {
                window.open("frmbackupstaus.aspx?mail=yes");
            }
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div data-ng-app="myApp" data-ng-controller="myCtrl" id="MyBody">
            <div class="container-fluid ">
            <nav class="navbar navbar-inverse" style="margin-bottom: 10px;">
                    <div class="container-fluid">
                        <div class="navbar-header" style="margin-left: 0px; margin-right: 0px; width: 100%;margin-bottom:10px;">
                            <div class="inline">
                                <div class="pull-left">
                                    <a class="navbar-brand " href="#">Backup Clients</a>
                                </div>
                                <div class="pull-right">
                                    <a class="backbutton" style="color: whitesmoke; display: block; text-align: center; padding: 14px 16px; margin-top: 0px; text-decoration: none;" data-ng-click="logout()"><span class="glyphicon glyphicon-log-out"></span> LogOut</a>
                                </div>
                                <div class="pull-right">
                                    <a class="backbutton" style="color: whitesmoke; display: block; text-align: center; padding: 14px 16px; margin-top: 0px; text-decoration: none;" data-ng-click="Back()"><span class="glyphicon glyphicon-chevron-left"></span> Back</a>
                                </div>
                                <div class="pull-right">
                                    <a class="backbutton" style="color: whitesmoke; display: block; text-align: center; padding: 14px 16px; margin-top: 0px; text-decoration: none;" data-ng-click="openClientdetails()"><span class="	glyphicon glyphicon-plus"></span> Add</a>
                                </div>
                                 <div class="pull-right">
                                    <a class="backbutton" style="color: whitesmoke; display: block; text-align: center; padding: 14px 16px; margin-top: 0px; text-decoration: none;" data-ng-click="openbackups()"><span class="glyphicon glyphicon-hourglass"></span> Backup Status</a>
                                </div>
                                <div class="pull-right">
                                    <a class="backbutton" style="color: whitesmoke; display: block; text-align: center; padding: 14px 16px; margin-top: 0px; text-decoration: none;" data-ng-click="mailbackupstatus()"><span class="glyphicon glyphicon-envelope"></span> Mail Backup Status</a>
                                </div>
                            </div>
                        </div>

                    </div>
                </nav>

                <table class="table table-striped">
                    <thead>
                        <tr >
                            <th></th>
                            <th>Code</th>
                            <th>Name</th>
                            <th>Connection</th>
                            <th>Ap Database</th>
                            <th>Ap_lab Database</th>
                            <th>Pharmacy Database</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody style="background-color:whitesmoke;">
                        <tr data-ng-repeat="obj in arr">
                            <td><span class="glyphicon glyphicon-user"></span></td>
                            <td>{{obj.code}}</td>
                            <td>{{obj.name}}</td>
                            <td>{{obj.connection_string}}</td>
                            <td>{{obj.ap_db_name}}</td>
                            <td>{{obj.aplab_db_name}}</td>
                            <td>{{obj.pharmacy_db_name}}</td>
                            <td><button type="button" class="btn" data-ng-click="openClient(obj.code)">Edit</button></td>
                        </tr>
                    </tbody>
                </table>
                </div>
        </div>
    </form>
</body>
</html>
