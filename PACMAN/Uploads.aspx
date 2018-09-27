<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Uploads.aspx.cs" Inherits="Uploads" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>
<asp:Content ID="three" ContentPlaceHolderID="headPlaceHolder" runat="server">

    <link href="Sitel/cdn/dropzonejs/dropzone.css" rel="stylesheet" />
    <style type="text/css">
        html, body {
            height: 100%;
        }
        /* Mimic table appearance */
        div.table {
            display: table;
        }

            div.table .file-row {
                display: table-row;
            }

                div.table .file-row > div {
                    display: table-cell;
                    vertical-align: top;
                    border-top: 1px solid #ddd;
                    padding: 8px;
                }

                div.table .file-row:nth-child(odd) {
                    background: #f9f9f9;
                }
        /* The total progress gets shown by event listeners */
        #total-progress {
            opacity: 0;
            transition: opacity 0.3s linear;
        }
        /* Hide the progress bar when finished */
        #previews .file-row.dz-success .progress {
            opacity: 0;
            transition: opacity 0.3s linear;
        }
        /* Hide the delete button initially */
        #previews .file-row .delete {
            display: none;
        }
        /* Hide the start and cancel buttons and show the delete button */
        #previews .file-row.dz-success .start,
        #previews .file-row.dz-success .cancel {
            display: none;
        }

        #previews .file-row.dz-success .delete {
            display: block;
        }
    </style>
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
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <div id="DropBox" class="box box-primary box-solid needsclick">
        <div class="box-header with-border needsclick">
            <h4 class="box-title needsclick">Drag & Drop Excel Files to this DropBox.</h4>
            <div id="actions" class="box-tools pull-right needsclick">
                <!-- The fileinput-button span is used to style the file input field as button -->
                <span class="btn btn-info btn-box-tool fileinput-button">
                    <i class="glyphicon glyphicon-plus"></i>
                    <span>Add files...</span>
                </span>
                <button type="button" class="btn btn-success btn-box-tool start">
                    <i class="glyphicon glyphicon-upload"></i>
                    <span>Start upload</span>
                </button>
                <button type="reset" class="btn btn-warning btn-box-tool cancel">
                    <i class="glyphicon glyphicon-ban-circle"></i>
                    <span>Cancel upload</span>
                </button>
                <!-- The global file processing state -->
                <span class="fileupload-process">
                    <div id="total-progress" class="progress xs progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
                        <div class="progress-bar progress-bar-success" style="width: 0%;" data-dz-uploadprogress></div>
                    </div>
                </span>
            </div>
        </div>
        <div class="box-body needsclick">
            <div class="table table-striped files" id="previews">
                <div id="template" class="file-row">
                    <!-- This is used as the file preview template -->
                    <div>
                        <span class="preview"><img data-dz-thumbnail /></span>
                    </div>
                    <div>
                        <p class="name" data-dz-name></p>
                        <strong class="error text-danger" data-dz-errormessage></strong>
                    </div>
                    <div>
                        <p class="size" data-dz-size></p>
                        <div class="progress xs progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
                            <div class="progress-bar progress-bar-success" style="width: 0%;" data-dz-uploadprogress></div>
                        </div>
                    </div>
                    <div>
                        <select id="ddlTask" class="form-control select2" data-placeholder="Please Select the Task for this particular Uploads">
                            <option id="" value=""></option>                            
                        </select>
                        <%--<button class="btn btn-sm btn-primary start">
                            <i class="glyphicon glyphicon-upload"></i>
                            <span>Start</span>
                        </button>--%>
                        <button data-dz-remove class="btn btn-sm  btn-warning cancel">
                            <i class="glyphicon glyphicon-ban-circle"></i>
                            <span>Cancel</span>
                        </button>
                        <%--<button data-dz-remove class="btn btn-sm  btn-danger delete">
                            <i class="glyphicon glyphicon-trash"></i>
                            <span>Delete</span>
                        </button>--%>
                    </div>
                </div>
            </div>
        </div>
        <%--<button id="btnUpload" class="btn btn-flat btn-primary needsclick">Upload Selected Files</button>--%>
    </div>
</asp:Content>
<asp:Content ID="two" ContentPlaceHolderID="below_footer" runat="server">
    <script src="Sitel/cdn/dropzonejs/dropzone.js"></script>
    <script type="text/javascript">

        var selectedFiles;
        Dropzone.autoDiscover = false;
        // Get the template HTML and remove it from the doumenthe template HTML and remove it from the doument
        var previewNode = document.querySelector("#template");
        previewNode.id = "";
        var previewTemplate = previewNode.parentNode.innerHTML;
        previewNode.parentNode.removeChild(previewNode);

        var myDropzone = new Dropzone(document.body, { // Make the whole body a dropzone
            url: "UploadHelper.ashx", // Set the url
            thumbnailWidth: 60,
            thumbnailHeight: 60,
            parallelUploads: 20,
            uploadMultiple: true,
            previewTemplate: previewTemplate,
            autoQueue: false, // Make sure the files aren't queued until manually added
            previewsContainer: "#previews", // Define the container to display the previews
            clickable: ".fileinput-button", // Define the element that should be used as click trigger to select files.
            accept: function (file, done) {
                var contains = file.name.indexOf(".xls");
                if (contains < 0) {
                    done("Invalid File.(Excel)");
                }
                else { done(); }
            }
        });

        myDropzone.on("addedfile", function (file) {
            // Hookup the start button
            file.previewElement.querySelector(".start").onclick = function () {
                myDropzone.enqueueFile(file);
            };
            if (file.type.match(/.xl*/)) {
                // This is not an image, so Dropzone doesn't create a thumbnail.
                // Set a default thumbnail:
                myDropzone.emit("thumbnail", file, "Sitel/img/excel.png");
            } else {
                myDropzone.emit("thumbnail", file, "Sitel/img/not-allowed.png");
            }
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
    </script>
</asp:Content>
