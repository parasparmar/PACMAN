<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Uploads.aspx.cs" Inherits="Uploads" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>


<asp:Content ID="three" ContentPlaceHolderID="headPlaceHolder" runat="server">

    <link href="Sitel/cdn/dropzonejs/dropzone.css" rel="stylesheet" />

</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="pacman.aspx">
            <i class="fa fa-dropbox"></i>DropBox</a></li>
    </ol>
    <div class="pageheader">
        <div class="pageicon">
            <i class="fa fa-dropbox"></i>
        </div>
        <div class="pagetitle">
            <h5>Upload data to the server using simple drag and drop functionality</h5>
            <h1>DropBox</h1>
        </div>
    </div>
    <!--pageheader-->
    <style type="text/css">
        .modal {
            background: rgba(0,0,0,.7) !important;
        }

        .clscustomcenter {
            width: 0%;
            margin: 20% auto;
            padding: 10px;
            opacity: 1;
            z-index: 1000;
        }

            .clscustomcenter img {
                border-radius: 5px;
            }

            .clscustomcenter .clsloadtxt {
                display: block;
                padding-top: 12px;
                color: #fff;
                letter-spacing: 1px;
            }
    </style>

</asp:Content>

<%--Comment--%>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">

    <div id="DropBox" class="box box-primary box-solid needsclick">
        <div class="box-header with-border needsclick">
            <h4 class="box-title needsclick">Drag & Drop Excel Files to this DropBox.</h4>
            <div class="box-tools pull-right needsclick">
                <button class="btn btn-box-tool needsclick" type="button" data-widget="remove"><i class="fa fa-times"></i></button>
            </div>
        </div>
        <div class="box-body needsclick">
            <div class="dz-default dz-message needsclick">
                Drop files here.                        
            </div>
            <div id="previews" class="dropzone-previews">
            </div>
        </div>
        <div class="box-footer">
            <button id="btnUpload" class="btn btn-flat btn-primary needsclick">Upload Selected Files</button>
        </div>
    </div>

    <br />

</asp:Content>




<asp:Content ID="two" ContentPlaceHolderID="below_footer" runat="server">
    <script src="Sitel/cdn/dropzonejs/dropzone.js"></script>
    <script type="text/javascript">
        var selectedFiles;
        $(document).ready(function () {
            Dropzone.autoDiscover = false;
            $("#DropBox").dropzone({
                url: "UploadHelper.ashx",
                maxFilesize: 10, // MB
                maxFiles: 5,
                addRemoveLinks: true,
                accept: function (file, done) {
                    var filename = file.name
                    var contains = filename.indexOf(".xls");
                    if (contains < 0) {
                        done("Invalid File Format - Not Excel.");
                    }
                    else { done(); }
                },
                previewsContainer: "#previews",
                autoProcessQueue: false,
                init: function () {
                    var submitButton = document.querySelector("#btnUpload");
                    myDropzone = this; // closure
                    submitButton.addEventListener("click", function () {
                        myDropzone.processQueue(); // Tell Dropzone to process all queued files.
                    });
                    // You might want to show the submit button only when 
                    // files are dropped here:
                    this.on("addedfile", function () {
                        // Show submit button here and/or inform user to click it.
                    });

                },
                success: function (file, response) {                    
                    var imgName = response;
                    file.previewElement.classList.add("dz-success");
                    console.log("Successfully uploaded :" + imgName);
                },
                error: function (file, response) {
                    file.previewElement.classList.add("dz-error");
                },

                
            });
        });

    </script>
</asp:Content>
