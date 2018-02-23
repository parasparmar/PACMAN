﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Security;
using System.Security.Principal;
using System.Net;



public partial class leave : System.Web.UI.Page
{
    DataTable dt;
    Helper my;
    string strsql;
    int MyEmpID;

    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();
        try
        {
            dt = Session["dtEmp"] as DataTable;
            if (dt.Rows.Count <= 0)
            {
                Response.Redirect("index.aspx", false);
            }
            else
            {
                // In Production Use the below
                MyEmpID = Convert.ToInt32(dt.Rows[0]["Employee_Id"].ToString());

                if (!Int32.TryParse(MyEmpID.ToString(), out MyEmpID))
                {
                    Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
                }

            }

        }
        catch (Exception Ex)
        {
            Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            Response.Write(Ex.Message);
        }

        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Leave Request";

        my.fill_dropdown(ddl_leave_dropdown, "WFMP.getDefaultLeaveType", "LeaveText", "LeaveId", "", "", "S");
        if (!IsPostBack)
        {
            fillgvLeaveLog();
        }


    }
    protected void btn_proceed_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Message", "<script>$(document).ready(function(){ $('#pnlLeaveBox').css({ 'display': 'block' });})</script>", false);


        //pnlLeaveBox.Visible = true;
        fillgvLeaveDetails();
        //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "pluginsInitializer()", true);
        //  ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Key1", "pluginsInitializer()", true);
    }
    protected void reservation_TextChanged(object sender, EventArgs e)
    {
        string received = reservation.Text;
        string[] seperator = { " - " };
        DateTime fromDate = Convert.ToDateTime(received.Split(seperator, StringSplitOptions.None).First<string>());
        DateTime endDate = Convert.ToDateTime(received.Split(seperator, StringSplitOptions.None).Last<string>());
        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Key1", "pluginsInitializer()", true);


    }

    private void fillgvLeaveDetails()
    {
        string received = reservation.Text;
        string[] seperator = { " - " };
        DateTime from_Date = Convert.ToDateTime(received.Split(seperator, StringSplitOptions.None).First<string>());
        DateTime end_Date = Convert.ToDateTime(received.Split(seperator, StringSplitOptions.None).Last<string>());
        strsql = "select CONVERT(VARCHAR,xDate,106) as Date,'' day,'' Leave,'' from [xGetdateBetween]('d','" + from_Date + "','" + end_Date + "') ";
        DataTable dt = my.GetData(strsql);
        ViewState["Paging"] = dt;  
        gvLeaveDetails.DataSource = dt;
        gvLeaveDetails.DataBind();

        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Key2", "pluginsInitializer()", true);

    }



    protected void gvLeaveDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        GridView gv = (GridView)sender;
        GridViewRow gvr = (GridViewRow)e.Row;
        if (gvr.RowIndex >= 0)
        {
            var thedate = gvr.Cells[0];
            DateTime ondate = Convert.ToDateTime(thedate.Text);

            var lbl = gvr.Cells[1];
            lbl.Text = ondate.DayOfWeek.ToString();

            DropDownList ddl = (DropDownList)gvr.FindControlRecursive("ddlSelectLeave");
            strsql = "select LeaveId, LeaveText from WFMP.tblLeaveType";
            DataTable dt = my.GetData(strsql);

            ddl.DataSource = dt;
            ddl.DataValueField = "LeaveId";
            ddl.DataTextField = "LeaveText";
            ddl.DataBind();
        }
    }

    private void fillgvLeaveLog()
    {

        strsql = "CWFM_UMANG.[WFMP].[buildBadges]";

        SqlCommand cmd = new SqlCommand(strsql);
        cmd.Parameters.AddWithValue("@ECN", Convert.ToInt32(MyEmpID.ToString()));
        //DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        //ddlRepManager.DataSource = dt1;
        //ddlRepManager.DataTextField = "MgrName";
        //ddlRepManager.DataValueField = "MgrID";
        //ddlRepManager.DataBind();
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        gvLeaveLog.DataSource = dt;
        gvLeaveLog.DataBind();
    }

    private void clearfields()
    {
        ddl_leave_dropdown.ClearSelection();
        txt_leave_reason.Text=string.Empty;//.InnerText 
        gvLeaveDetails.DataSource = null;
        gvLeaveDetails.DataBind();
    }

    protected void gvLeaveLog_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        GridView gv = (GridView)sender;
        GridViewRow gvr = (GridViewRow)e.Row;
        if (gvr.RowIndex >= 0)// && e.Row.RowIndex == gv.EditIndex
        {
            int dt;
            Button btn = (Button)gvr.FindControlRecursive("btn_Cancel");
            //btn.Text = "X";

            string stat1 = gvr.Cells[7].Text.ToString();
            string stat2 = gvr.Cells[8].Text.ToString();
            string date = gvr.Cells[9].Text.ToString();
            if (date == "&nbsp;")
            {
                dt = 0;
            }
            else
            {
                dt = 1;
            }
            //int dt = Convert.ToInt32(date);
            //DateTime canceldate = Convert.ToDateTime(date);
            //from_date
            string fdate = gvr.Cells[0].Text.ToString();
            DateTime fromdate = Convert.ToDateTime(fdate);
            DateTime today = DateTime.Today;

            if (stat1 == "Declined" || today > fromdate || dt==1 || stat2 == "declined")//
            {
                btn.CssClass = "btn btn-sm btn-danger disabled";
                btn.Enabled = false;
            }

        }
    }
    protected void btn_submit_Click(object sender, EventArgs e)
    {
        string received = reservation.Text;
        string[] seperator = { " - " };
        DateTime from_Date = Convert.ToDateTime(received.Split(seperator, StringSplitOptions.None).First<string>());
        DateTime end_Date = Convert.ToDateTime(received.Split(seperator, StringSplitOptions.None).Last<string>());



        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "CWFM_UMANG.WFMP.InsertLeaveRecords";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;
        MyEmpID = Convert.ToInt32(dt.Rows[0]["Employee_Id"].ToString());
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        cmd.Parameters.AddWithValue("@from_date", from_Date);
        cmd.Parameters.AddWithValue("@to_date", end_Date);
        cmd.Parameters.AddWithValue("@leave_reason", txt_leave_reason.Text.ToString());
        cmd.Parameters.Add("@xLEAVE_BATCH_ID", SqlDbType.VarChar, 500);
        cmd.Parameters["@xLEAVE_BATCH_ID"].Direction = ParameterDirection.Output;
        cmd.Parameters.Add("@stop", SqlDbType.Int);
        cmd.Parameters["@stop"].Direction = ParameterDirection.Output;
        cmd.Connection = con;

        cmd.ExecuteNonQuery();
        con.Close();

        string dec = cmd.Parameters["@stop"].Value.ToString();
        if (String.IsNullOrEmpty(dec))
            
        {
            string xLeaveBatchID = cmd.Parameters["@xLEAVE_BATCH_ID"].Value.ToString();



            string xRoster;
            foreach (GridViewRow row in gvLeaveDetails.Rows)
            {
                String xLeaveType;
                String xDate;
                //ddlSelectLeave

                DropDownList xDDL = (DropDownList)row.FindControl("ddlSelectLeave");

                xLeaveType = xDDL.SelectedValue.ToString();

                xDate = row.Cells[0].Text;
                //    xRoster = row.Cells[3].Text;

                //if (xRoster == "&nbsp;")
                //{
                //    xRoster = "";
                //}

                //strSQL = "INSERT INTO WFMP.tbl_datewise_leave VALUES('" + xDate + "','" + xLeaveType + "','" + xRoster + "','" + xLeaveBatchID + "')";
                strSQL = "INSERT INTO WFMP.tbl_datewise_leave(LeaveDate,leave_type,leave_batch_id) VALUES('" + xDate + "','" + xLeaveType + "','" + xLeaveBatchID + "')";

                try
                {
                    con.Open();
                    cmd = new SqlCommand(strSQL, con);
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
                catch (Exception ex)
                {

                }

            }
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", "toastr.success('Leave applied successfully.')", true);

            fillgvLeaveLog();

        }
        else
        {
            int stop = Convert.ToInt32(dec);
            if (stop == 1)
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "show", "error();", true);
                Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", "toastr.warning('Current Leave applied coincides with previous uncalled leave .Kindly Reapply.')", true);

            }

        }
        
            clearfields();      
    }


    string fdate { get; set; }
    string tdate { get; set; }//imp
    protected void btn_Cancel_Click(object sender, EventArgs e)
    {
        //    
        //ScriptManager.RegisterStartupScript(this, this.GetType(), "xKeyx", "xShowModal()", true);
        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "xKeyx", "openmodal", true);
        Button btn = (Button)sender;
        GridViewRow row = (GridViewRow)btn.NamingContainer;


        fdate = row.Cells[0].Text.ToString();
        tdate = row.Cells[1].Text.ToString();
    }

    protected void btn_save_cancel_reason_Click(object sender, EventArgs e)
    {

        string cancel_reason = txt_cancel_reason.Text.ToString();
        string id = (lblLeaveID.Value); 
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();
        //string fdate = row.Cells[0].Text.ToString();
        //string tdate = row.Cells[1].Text.ToString();
        DateTime from_date = Convert.ToDateTime(fdate);
        DateTime to_date = Convert.ToDateTime(tdate);
        DateTime date = DateTime.Now;
        string CancelDate = date.ToString("yyyy-MM-dd HH:mm:ss.fff");


        String Sql = "UPDATE [WFMP].[tbl_leave_request]";
        Sql += "SET [cancel_reason]='" + cancel_reason + "', [CancelDate]='" + CancelDate + "'";

        Sql += "WHERE [id] = '" + id + "'";

        SqlCommand cmd = new SqlCommand(Sql, con);
        cmd.Connection = con;
       int Rows= cmd.ExecuteNonQuery();
        con.Close();
        txt_cancel_reason.Text = String.Empty;
        
        //Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", "toastr.success('Request Declined.', 'Success')", true);
        fillgvLeaveLog();
        if (Rows > 0) {
            //System.Text.StringBuilder sb = new System.Text.StringBuilder();

            //sb.Append(@"<script language='javascript'>");

            //sb.Append(@"toast();");

            //sb.Append(@"</script>");



            //if (!ClientScript.IsStartupScriptRegistered("JSScript"))
            //{

            //    ClientScript.RegisterStartupScript(this.GetType(), "JSScript", sb.ToString());

            //}
            //ClientScript.RegisterClientScriptBlock(GetType(), "toast", "javascript: toast(); ");
            //ClientScript.RegisterStartupScript(GetType(), "toast", "javascript: toast(); ", true);/////////

            //ScriptManager.RegisterStartupScript(this, this.GetType(), "OpenPage", "<script>toastr.success('Have fun storming the castle!', 'Miracle Max Says');</script>", true);
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "Message", "toast();", true);
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", "toastr.success('Cancellation is successfull.')", true);
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "Message", "<script>$(document).ready(function(){ $('.call').css({ 'display': 'block' });});</script>", false);
        }

    }

   

    [WebMethod]
    public static string getDates()
    {
        Helper my = new Helper();

        String strSQL = "CWFM_UMANG.WFMP.[getMinDateforLeaveRequest]";
        SqlCommand cmd = new SqlCommand(strSQL);
        DataTable dtMinDate = my.GetDataTableViaProcedure(ref cmd);
        string minDate =dtMinDate.Rows[0]["minDate"].ToString();
        //JavaScriptSerializer js = new JavaScriptSerializer();

        //return js.Serialize(minDate); 
        return (minDate);


    }

    protected void gvLeaveLog_PreRender(object sender, EventArgs e)
    {
        //GridView gv = (GridView)sender;
        //if (gv.Rows.Count > 0)
        //{
        //    gv.UseAccessibleHeader = true;
        //    gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        //    gv.FooterRow.TableSection = TableRowSection.TableFooter;
        //    gv.HeaderStyle.BorderStyle = BorderStyle.None;
        //    gv.BorderStyle = BorderStyle.None;
        //    gv.BorderWidth = Unit.Pixel(1);
        //}

    }
    protected void gvLeaveLog_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvLeaveLog.PageIndex = e.NewPageIndex; 
        fillgvLeaveLog();

    }
    protected void gvLeaveLog_Sorting(object sender, GridViewSortEventArgs e)
    {
        DataTable dt = Session["TaskTable"] as DataTable;

        if (dt != null)
        {

            //Sort the data.
            dt.DefaultView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression);
            gvLeaveLog.DataSource = Session["TaskTable"];
            gvLeaveLog.DataBind();
        }

    }
    private string GetSortDirection(string column)
    {

        // By default, set the sort direction to ascending.
        string sortDirection = "ASC";

        // Retrieve the last column that was sorted.
        string sortExpression = ViewState["SortExpression"] as string;

        if (sortExpression != null)
        {
            // Check if the same column is being sorted.
            // Otherwise, the default value can be returned.
            if (sortExpression == column)
            {
                string lastDirection = ViewState["SortDirection"] as string;
                if ((lastDirection != null) && (lastDirection == "ASC"))
                {
                    sortDirection = "DESC";
                }
            }
        }

        // Save new values in ViewState.
        ViewState["SortDirection"] = sortDirection;
        ViewState["SortExpression"] = column;

        return sortDirection;
    }
}

        

