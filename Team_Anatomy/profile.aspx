﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="profile.aspx.cs" Inherits="profile" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
</asp:Content>
<%--<asp:Content ID="Content2" ContentPlaceHolderID="headmenu" runat="Server">
</asp:Content>--%>
<%--<asp:Content ID="Content3" ContentPlaceHolderID="leftmenu" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="profile.aspx"><i class="fa fa-user-plus"></i>Profile Information</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-user-plus"></span></div>
        <div class="pagetitle">
            <h5>View / Edit and Save Profile Information</h5>
            <h1>My Profile</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <div class="row">
        <div class="col-md-4">
            <!-- Profile Image -->
            <div class="box box-primary">
                <div class="box-body box-profile">
                    <asp:Image ID="imgbtnUserImage" CssClass="profile-user-img img-responsive img-circle" runat="server" />
                    <h3 class="profile-username text-center">
                        <asp:Label ID="lblName" runat="server"></asp:Label>
                    </h3>
                    <p class="text-muted text-center">
                        Employee :
                    <b><a class="pull-none">
                        <asp:Label ID="lblEmployee_ID" runat="server"></asp:Label></a></b>
                    </p>
                    <p class="text-muted text-center">
                        Windows ID :
                    <b><a class="pull-none">
                        <asp:Label ID="lblNTID" runat="server"></asp:Label></a></b>
                    </p>
                    <ul class="list-group list-group-unbordered">
                        <li class="list-group-item">
                            <b>Designation</b><a class="pull-right"><asp:Label ID="lblDesignation" runat="server"></asp:Label></a>
                        </li>
                        <li class="list-group-item">
                            <b>Department</b><a class="pull-right"><asp:Label ID="lblDepartment" runat="server"></asp:Label></a>
                        </li>
                        <li class="list-group-item">
                            <b>Date of Joining</b><a class="pull-right"><asp:Label ID="lblDOJ" runat="server"></asp:Label></a>
                        </li>
                        <li class="list-group-item">
                            <b>Email id</b> <a class="pull-right">
                                <asp:Label ID="lblEmailID" runat="server"></asp:Label></a>
                        </li>
                        <li class="list-group-item">
                            <b>Contact Number</b> <a class="pull-right">
                                <asp:Label ID="lblContactNumber" runat="server"></asp:Label></a>
                        </li>
                    </ul>

                    <%--<a href="#" class="btn btn-primary btn-block"><b>Request Rectification</b></a>--%>
                </div>
                <!-- /.box-body -->
            </div>
            <!-- /.box -->
            <!-- Employee Information Box -->
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">Employee Information</h3>
                </div>
                <!-- /.box-header -->
                <div class="box-body">
                    <ul class="list-group list-group-unbordered">
                        <li class="list-group-item">
                            <strong>Reporting Manager</strong>
                            <a class="pull-right">
                                <asp:Label ID="lblSupervisor" runat="server"></asp:Label>
                            </a>
                        </li>

                        <li class="list-group-item">
                            <strong>Employee Role</strong>
                            <a class="pull-right">
                                <asp:Label ID="lblEmployee_Role" runat="server"></asp:Label>
                            </a>

                        </li>
                        <li class="list-group-item">
                            <strong>Employee Type</strong>
                            <a class="pull-right">
                                <asp:Label ID="lblEmployee_Type" runat="server"></asp:Label>
                            </a>

                        </li>
                        <li class="list-group-item">
                            <strong>Employee Status</strong>
                            <a class="pull-right">
                                <asp:Label ID="lblEmployee_Status" runat="server"></asp:Label>
                            </a>

                        </li>
                        <li class="list-group-item">
                            <strong>Updated by</strong>
                            <a class="pull-right">
                                <asp:Label ID="lblUpdated_by" runat="server"></asp:Label>
                            </a>

                        </li>
                        <li class="list-group-item">
                            <strong>Update_Date</strong>
                            <a class="pull-right">
                                <asp:Label ID="lblUpdate_Date" runat="server"></asp:Label>
                            </a>

                        </li>
                        <li class="list-group-item">
                            <strong>Site</strong>
                            <a class="pull-right">
                                <asp:Label ID="lblSite" runat="server"></asp:Label>
                            </a>

                        </li>

                    </ul>
                    <%-- <a href="#" class="btn btn-primary btn-block"><b>Request Rectification</b></a>--%>
                </div>
                <!-- /.box-body -->
            </div>
            <!-- /.box -->
        </div>

        <%--        <asp:Panel ID="resultofsave" runat="server" Visible="true" CssClass="col-md-8">
            <div class="alert alert-success alert-dismissible">
                <button class="close" aria-hidden="true" type="button" data-dismiss="alert">×</button>
                <h4><i class="icon fa fa-check"></i>
                    <asp:Literal ID="ltlresultofsave" Text="Saved Successfully!" runat="server"></asp:Literal></h4>
                <asp:Label ID="lblresultofsave" Text="Your data has been saved successfully." runat="server"></asp:Label>
            </div>
        </asp:Panel>--%>

        <div class="col-md-8">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#personal" data-toggle="tab">Personal</a></li>
                    <li><a href="#transport" data-toggle="tab">Transport</a></li>
                    <li><a href="#work_experience" data-toggle="tab">Work Experience</a></li>
                    <li><a href="#profile_image" data-toggle="tab">Profile Image</a></li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="personal">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbGender" class="col-sm-2 control-label">Gender</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-genderless"></i></span>
                                        <asp:DropDownList ItemType="text" CssClass="form-control select" ID="tbGender" runat="server" placeholder="Gender" type="text">
                                            <asp:ListItem Text="Male"></asp:ListItem>
                                            <asp:ListItem Text="Female"></asp:ListItem>
                                            <asp:ListItem Text="Not Specified"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbDate_of_Birth" class="col-sm-2 control-label">Date of Birth</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-birthday-cake"></i></span>
                                        <asp:TextBox ID="tbDate_of_Birth" CssClass="form-control datepicker" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbHighest_Qualification" class="col-sm-2 control-label">Highest Qualification</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-university"></i></span>
                                        <asp:DropDownList ItemType="text" CssClass="form-control  select2" ID="tbHighest_Qualification" Style="width: 100%" runat="server">
                                            <asp:ListItem Value="" Text="Please select your highest education level"></asp:ListItem>
                                            <asp:ListItem Value="NONE" Text="Some High School"></asp:ListItem>
                                            <asp:ListItem Value="HS" Text="High School"></asp:ListItem>
                                            <asp:ListItem Value="DIPLOMA" Text="Diploma"></asp:ListItem>
                                            <asp:ListItem Value="COLLEGE" Text="College"></asp:ListItem>
                                            <asp:ListItem Value="ASSOCIATE" Text="Associate's Degree"></asp:ListItem>
                                            <asp:ListItem Value="BACHELOR" Text="Bachelor's Degree"></asp:ListItem>
                                            <asp:ListItem Value="MASTER" Text="Master's Degree"></asp:ListItem>
                                            <asp:ListItem Value="DOCTOR" Text="Doctorate Degree"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbMarital_Status" class="col-sm-2 control-label">Marital Status</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-user-plus"></i></span>
                                        <asp:DropDownList ItemType="text" CssClass="form-control select" ID="tbMarital_Status" runat="server">
                                            <asp:ListItem Text="Married"></asp:ListItem>
                                            <asp:ListItem Text="Not Married"></asp:ListItem>
                                            <asp:ListItem Text="Not Specified"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="inputSkills" class="col-sm-2 control-label">Anniversary (if Married)</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-calendar-check-o"></i></span>
                                        <asp:TextBox ID="tbAnniversaryDate" CssClass="form-control datepicker" runat="server"></asp:TextBox>
                                    </div>

                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbContact_Number" class="col-sm-2 control-label">Contact Number</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-mobile"></i></span>
                                        <asp:TextBox ID="tbContact_Number" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAlternate_Contact" class="col-sm-2 control-label">Alternate Number</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-phone-square"></i></span>
                                        <asp:TextBox ID="tbAlternate_Contact" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tb" class="col-sm-2 control-label">Emergency Contact Person</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-phone-square"></i></span>
                                        <asp:TextBox ID="tbEmergencyContactPerson" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="tbEmail_id" class="col-sm-2 control-label">Email id (Personal)</label>
                                <div class="col-sm-10">

                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-envelope"></i></span>
                                        <asp:TextBox ID="tbEmail_id" CssClass="form-control" type="email" runat="server" placeholder="Email"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-sm-offset-2 col-sm-10">
                                    <asp:Button ID="btnPersonalSubmit" runat="server" CssClass="btn btn-danger" Text="Submit" OnClick="btnPersonalSubmit_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /.tab-pane Edit Personal Data-->
                    <div class="tab-pane" id="transport">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbTransport_User" class="col-sm-2 control-label">Transport User</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-automobile"></i></span>
                                        <asp:DropDownList ItemType="text" CssClass="form-control select" ID="tbTransport_User" runat="server">
                                            <asp:ListItem Text="Yes"></asp:ListItem>
                                            <asp:ListItem Text="No"></asp:ListItem>
                                            <asp:ListItem Text="Not Specified"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_Line_1" class="col-sm-2 control-label">Address Line 1</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-hotel"></i></span>
                                        <asp:TextBox ID="tbAddress_Line_1" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_Line_2" class="col-sm-2 control-label">Address Line 2</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-hotel"></i></span>
                                        <asp:TextBox ID="tbAddress_Line_2" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_Landmark" class="col-sm-2 control-label">Address Landmark</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-hotel"></i></span>
                                        <asp:TextBox ID="tbAddress_Landmark" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_City" class="col-sm-2 control-label">Address City</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-hotel"></i></span>
                                        <asp:TextBox ID="tbAddress_City" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_Country" class="col-sm-2 control-label">Address Country</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-hotel"></i></span>
                                        <asp:TextBox ID="tbAddress_Country" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbPermanent_Address_City" class="col-sm-2 control-label">Permanent Address City</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-home"></i></span>
                                        <asp:TextBox ID="tbPermanent_Address_City" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-sm-offset-2 col-sm-10">
                                    <asp:Button ID="btnTransportSubmit" CssClass="btn btn-danger" runat="server" Text="Submit" OnClick="btnPersonalSubmit_Click" />

                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /.tab-pane -->
                    <div class="tab-pane" id="work_experience">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbTotal_Work_Experience" class="col-sm-2 control-label">Total Work Experience</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-briefcase"></i></span>

                                        <asp:TextBox ID="tbTotal_Work_Experience" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbSkill_Set_1" class="col-sm-2 control-label">Primary Skill Set</label>
                                <div class="col-sm-10">

                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-rocket"></i></span>
                                        <select id="tbSkill_Set_1" class="form-control select2" selectionmode="multiple" multiple="true" style="width: 100%" runat="server">
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbSkill_Set_2" class="col-sm-2 control-label">Secondary Skill Set</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-fighter-jet"></i></span>
                                        <select id="tbSkill_Set_2" class="form-control select2" selectionmode="multiple" multiple="true" style="width: 100%" runat="server"></select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbSkill_Set_3" class="col-sm-2 control-label">Tertiary Skill Set</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-bicycle"></i></span>
                                        <select id="tbSkill_Set_3" class="form-control select2" selectionmode="multiple" multiple="true" style="width: 100%" runat="server"></select>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-sm-offset-2 col-sm-10">
                                    <asp:Button ID="btnExperienceSubmit" CssClass="btn btn-danger" runat="server" Text="Submit" OnClick="btnPersonalSubmit_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /.tab-pane -->

                    <div class="tab-pane" id="profile_image">

                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbSkill_Set_3" class="col-sm-2 control-label">Change Profile Image</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <asp:FileUpload ID="fileUploadNewProfileImage" runat="server" />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-sm-offset-2 col-sm-10">
                                    The user profile image can also be updated simply by clicking on it and providing the new image.
                                </div>
                            </div>
                        </div>


                    </div>
                    <!-- /.tab-pane Edit Profile Image-->
                </div>
                <!-- /.tab-content -->
            </div>
            <!-- /.nav-tabs-custom -->
        </div>
        <!-- /.box -->
    </div>
    <!-- /.col -->

</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- Select2 -->
    <script src="AdminLTE/bower_components/select2/dist/js/select2.full.min.js"></script>
    <script>
        $(function () {
            //Date picker
            $("[class*='datepicker']").datepicker({
                autoclose: true
            })
            //Initialize Select2 Elements
            $("[class*='select2']").select2();

            $('#imgbtnUserImage').click(function () {
                $('input[type=file]').trigger('click');

            });

            $('input[type=file]').change(function () {
                var vals = $(this).val();
                var fileName = vals.length ? vals.split('\\').pop() : '';
                var fileExtension = fileName.split('.').pop();
                var fileUpload = $(this).get(0);
                var files = fileUpload.files;
                var data = new FormData();
                var myID = $("#lblNTID").val() + "_0." + fileExtension;
                for (var i = 0; i < files.length; i++) {
                    data.append(files[i].name, files[i], "pparm001_0.jpg");
                }

                //  

                // $('input[type=text]').val(val);
                //alert(filePath.toString());

                $.ajax({
                    url: "FileUploadHandler.ashx",
                    type: "POST",
                    data: data,
                    contentType: false,
                    processData: false,
                    success: function (result) {
                        alert(result);
                        location.reload();
                    },
                    error: function (err) { alert(err.statusText) }
                });



            });

        });
    </script>

</asp:Content>

