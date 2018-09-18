<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Uploads.aspx.cs" Inherits="Uploads" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>


<asp:Content ID="three" ContentPlaceHolderID="headPlaceHolder" runat="server">

    <link href="Sitel/cdn/dropzonejs/dropzone.css" rel="stylesheet" />
    <script src="Sitel/cdn/dropzonejs/dropzone.js"></script>
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
    <div id="DropBox" class="box box-primary box-solid">
        <div class="box-header with-border needsclick">
            <h4 class="box-title needsclick">Drag & Drop Excel Files to this DropBox.</h4>
            <div class="box-tools pull-right needsclick">
                <button class="btn btn-box-tool needsclick" type="button" data-widget="remove"><i class="fa fa-times"></i></button>
            </div>
        </div>
        <div class="box-body needsclick">
            <div class="table table-striped files needsclick" id="previews">
                
            </div>
        </div>
    </div>
    <br />
    <input id="btnUpload" type="button" value="Upload Selected Files" class="fileinput-button needsclick" />
</asp:Content>




<asp:Content ID="two" ContentPlaceHolderID="below_footer" runat="server">

    <script type="text/javascript">
        var selectedFiles;

        $(function () {

            $("#DropBox").dropzone({
                url: "UploadHelper.ashx",
                maxFilesize: 10, // MB
                accept: function (file, done) {
                    var filename = file.name
                    var contains = filename.indexOf(".xls");
                    if (contains < 0) {
                        done("Naha, you don't.");
                    }
                    else { done(); }
                }
            });


            //var DropBox;
            //DropBox = document.getElementById("DropBox");
            //DropBox.addEventListener("dragenter", OnDragEnter, false);
            //DropBox.addEventListener("dragover", OnDragOver, false);
            //DropBox.addEventListener("drop", OnDrop, false);
            $("#btnUpload").click(function () {
                var data = new FormData();
                for (var i = 0; i < selectedFiles.length; i++) {
                    data.append(selectedFiles[i].name, selectedFiles[i]);
                }
                $.ajax({
                    type: "POST",
                    url: "UploadHelper.ashx",
                    contentType: false,
                    processData: false,
                    data: data,
                    success: function (result) {
                        alert(result);
                    },
                    error: function () {
                        alert("There was error uploading files!");
                    }
                });
            });
        });

        function OnDragEnter(e) {
            e.stopPropagation();
            e.preventDefault();
        }

        function OnDragOver(e) {
            e.stopPropagation();
            e.preventDefault();
        }

        function OnDrop(e) {
            e.stopPropagation();
            e.preventDefault();
            selectedFiles = e.dataTransfer.files;
            var myFileList = "";
            ////debugger;

            for (var i = 0; i < selectedFiles.length; i++) {
                if (i == 0) {
                    myFileList = selectedFiles[i].name;
                } else {
                    myFileList = myFileList + '<br>' + selectedFiles[i].name;
                }
            }

            $("#previews").html(myFileList);
        }
    </script>
   <%-- <script>
        $(function () {
            // Get the template HTML and remove it from the doumenthe template HTML and remove it from the doument        
            var previewNode = document.querySelector("#template");
            previewNode.id = "";
            var previewTemplate = previewNode.parentNode.innerHTML;
            previewNode.parentNode.removeChild(previewNode);

            var myDropzone = new Dropzone(document.body, { // Make the whole body a dropzone
                url: "UploadHelper.ashx", // Set the url
                thumbnailWidth: 80,
                thumbnailHeight: 80,
                parallelUploads: 20,
                previewTemplate: previewTemplate,
                autoQueue: false, // Make sure the files aren't queued until manually added
                previewsContainer: "#previews", // Define the container to display the previews
                clickable: "#btnUpload" // Define the element that should be used as click trigger to select files.
            });

            myDropzone.on("addedfile", function (file) {
                // Hookup the start button
                file.previewElement.querySelector(".start").onclick = function () {
                    myDropzone.enqueueFile(file);
                };
            });

            // Update the total progress bar
            myDropzone.on("totaluploadprogress", function (progress) {
                document.querySelector("#total-progress .progress-bar").style.width = progress + "%";
            });

            myDropzone.on("sending", function (file) {
                // Show the total progress bar when upload starts
                document.querySelector("#total-progress").style.opacity = "1";
                // And disable the start button
                file.previewElement.querySelector(".start").setAttribute("disabled", "disabled");
            });

            // Hide the total progress bar when nothing's uploading anymore
            myDropzone.on("queuecomplete", function (progress) {
                document.querySelector("#total-progress").style.opacity = "0";
            });

            // Setup the buttons for all transfers
            // The "add files" button doesn't need to be setup because the config
            // `clickable` has already been specified.
            document.querySelector("#actions .start").onclick = function () {
                myDropzone.enqueueFiles(myDropzone.getFilesWithStatus(Dropzone.ADDED));
            };
            document.querySelector("#actions .cancel").onclick = function () {
                myDropzone.removeAllFiles(true);
            };

        });






    </script>--%>
</asp:Content>
