<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmbackupstaus.aspx.cs" Inherits="ClientDashBoard.MainMenu.frmbackupstaus" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Backup Status</title>
    <script src="../Scripts/bootstrap.js"></script>
    <script src="../Scripts/jquery-3.4.1.min.js"></script>
    <link href="../Content/bootstrap.min.css" rel="stylesheet" />

    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
    <style>
        body {
            display: grid;
        }

        .backbutton:hover {
            /*color:#2F2F2F;*/
            border-radius: 50px;
            background-color: #2F2F2F;
            color: white;
        }

        .navbar {
            background-color: whitesmoke;
            border-color: whitesmoke;
        }

        .navbar-brand {
            font-size: x-large;
        }

            .navbar-brand:hover {
                border-radius: 50px;
                background-color: #2F2F2F;
                color: white;
            }

        .backbutton {
            color: #2F2F2F;
        }

        table {
       
            background-color: whitesmoke;
            border-color:#2F2F2F;
        }

        .name {
            font-size: 14px;
        }

        th, td {
            text-align: center;
           
        }
        .thead-dark{
            background-color:#2F2F2F;
            color:white;
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
            $scope.Back = function () {
                window.history.back();
            }
            $scope.logout = function () {
                window.open("mainpage.aspx", "_self");
            }
            $scope.mail = getQueryString("mail", window.location.href);
            $http({
                method: "POST",
                url: "../WebServices/clientdash.asmx/getbackupstatus",
                data: {},
                datatype: 'json'
            }).then(function (response) {
                debugger;
                console.log(response.data.d);
                $scope.arr = response.data.d;
                if ($scope.mail != null) {
                    $http({
                        method: "POST",
                        url: "../WebServices/clientdash.asmx/sendbackupmail",
                        data: {},
                        datatype: 'json'
                    }).then(function (response) {
                        $scope.value = response;

                        var obj = new Object();
                        obj = response.data.d
                        if (obj.IsSaved == false) {
                            alert(obj.ErrorMsg);
                        }
                        else if (obj.IsSaved == true) {
                            alert(obj.SuccessMsg);

                        }

                    }).catch(function (response) {
                        debugger
                        var obj = new Object();
                        obj = response.data.Message;
                        alert(obj);
                        console.log(response.data);
                    });
                }

            });

            
            
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div data-ng-app="myApp" data-ng-controller="myCtrl" id="MyBody">
            <div class="container-fluid ">
                <nav class="navbar navbar-inverse" style="margin-bottom: 0px;">
                    <div class="container-fluid">
                        <div class="navbar-header" style="margin-left: 0px; margin-right: 0px; width: 100%;">
                            <div class="inline">
                                <div class="pull-left">
                                    <a class="navbar-brand " style="color: #2F2F2F" href="#">Backup Status</a>
                                </div>
                                <div class="pull-right">
                                    <a class="backbutton" style="display: block; text-align: center; padding: 14px 16px; margin-top: 0px; text-decoration: none; font-size: larger;" data-ng-click="logout()"><span class="glyphicon glyphicon-log-out"></span> LogOut</a>
                                </div>
                                <%--<div class="pull-right">
                                    <a class="backbutton" style="display: block; text-align: center; padding: 14px 16px; margin-top: 0px; text-decoration: none; font-size: larger;" data-ng-click="Back()"><span class="glyphicon glyphicon-chevron-left"></span> Back</a>
                                </div>--%>
                            </div>
                        </div>

                    </div>
                </nav>
                <hr style="color: black; margin-top: 5px; margin-bottom: 15px;" />

                <div class="row" style="display:flex">
                <hr style="width: 38%;margin-left:0px;margin-right:0px;color:black;"/>
                <label class="name" style="vertical-align: middle; text-align: center;margin-top:7px;">Online Backup status with more than 24hrs</label>
                <hr style="width: 38%;margin-left:0px;margin-right:0px;color:black;" />
                </div>
                <br />
                <table class="table table-bordered">
                    <thead class="thead-dark">
                        <tr>
                            <th rowspan="2"><span class="glyphicon glyphicon-user"></span>Client</th>
                            <th colspan="4">AP</th>
                            <th colspan="3">Lab</th>
                            <th colspan="3">Pharmacy</th>

                        </tr>
                        <tr>
                            <th>Last OPD Bill</th>
                            <th>Last IPD Discharge</th>
                            <th>Last Restored</th>
                            <th>Status</th>
                            <th>Last Lab</th>
                            <th>Last Restored</th>
                            <th>Status</th>
                            <th>Last Bill</th>
                            <th>Last Restored</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr data-ng-repeat="obj in arr[0]">
                            <td style="color:white;background-color:darkred">{{obj.clientname}}</td>
                            <td>{{obj.ap_opd_bill}}</td>
                            <td>{{obj.ap_ipd_discharge}}</td>
                            <td>{{obj.ap_restored}}</td>
                            <td>{{obj.ap_staus}}</td>
                            <td>{{obj.lab_lastlab}}</td>
                            <td>{{obj.lab_restored}}</td>
                            <td>{{obj.lab_staus}}</td>
                            <td>{{obj.pharma_last_bill}}</td>
                            <td>{{obj.pharma_restored}}</td>
                            <td>{{obj.pharma_staus}}</td>

                        </tr>
                    </tbody>
                </table>
                <br />
                <div class="row" style="display:flex">
                <hr style="width: 38%;margin-left:0px;margin-right:0px;color:black;"/>
                <label class="name" style="vertical-align: middle; text-align: center;margin-top:7px;">Online Backup status with less than 24hrs</label>
                <hr style="width: 38%;margin-left:0px;margin-right:0px;color:black;" />
                </div>
                <br />
                <table class="table table-bordered">
                    <thead class="thead-dark">
                        <tr>
                            <th rowspan="2"><span class="glyphicon glyphicon-user"></span>Client</th>
                            <th colspan="4">AP</th>
                            <th colspan="3">Lab</th>
                            <th colspan="3">Pharmacy</th>

                        </tr>
                        <tr>
                            <th>Last OPD Bill</th>
                            <th>Last IPD Discharge</th>
                            <th>Last Restored</th>
                            <th>Status</th>
                            <th>Last Lab</th>
                            <th>Last Restored</th>
                            <th>Status</th>
                            <th>Last Bill</th>
                            <th>Last Restored</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr data-ng-repeat="obj in arr[1]">
                            <td style="color:white;background-color:darkgreen">{{obj.clientname}}</td>
                            <td>{{obj.ap_opd_bill}}</td>
                            <td>{{obj.ap_ipd_discharge}}</td>
                            <td>{{obj.ap_restored}}</td>
                            <td>{{obj.ap_staus}}</td>
                            <td>{{obj.lab_lastlab}}</td>
                            <td>{{obj.lab_restored}}</td>
                            <td>{{obj.lab_staus}}</td>
                            <td>{{obj.pharma_last_bill}}</td>
                            <td>{{obj.pharma_restored}}</td>
                            <td>{{obj.pharma_staus}}</td>

                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
