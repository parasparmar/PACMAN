using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlTypes;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Sql;
using System.Data.SqlClient;


public partial class ExceptionTracker : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    string strSQL;
    int MyEmpID;
    string reportee { get; set; }
    //string pacmancycle { get; set; }

    EmailSender Email = new EmailSender();


    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();
        try
        {
            dtEmp = (DataTable)Session["dtEmp"];
            if (dtEmp.Rows.Count <= 0)
            {
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
            else
            {
                MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
            }

        }
        catch (Exception Ex)
        {
            Response.Write(Ex.Message);
        }

        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Exception Tracker";

        if (Convert.ToInt32(dtEmp.Rows[0]["LevelIDnumber"].ToString()) <= 75)
        { btnSave.Enabled = true; }
        else
        { btnSave.Enabled = false; }

        if (!IsPostBack)
        {
            fillddlInterval();
            fillddlAccount();
            fillddlLOB();
            //filllbSites();
            fillKPI();
            fillMonth();
            fillgvPendingLog();
        }
    }

    private void fillddlAccount()
    {
        string strSQL = "[WFMP].[fillEmployeeAccounts]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        if (dt1 != null && dt1.Rows.Count > 0)
        {

            ddlExceptionAccount.DataSource = dt1;
            ddlExceptionAccount.DataTextField = "Account";
            //ddlExceptionAccount.DataValueField = "PrimaryClientID";
            ddlExceptionAccount.DataValueField = "PrimaryClientID";
            ddlExceptionAccount.DataBind();
        }
        else
        {
            //ddlAccount.DataSource = dt1;
            ddlExceptionAccount.DataTextField = "No-Account";
            //ddlAccount.DataValueField = "PrimaryClientID"; 
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", "toastr.warning('Currently no accounts are mapped to you. For more support kindly contact iAccess team.')", true);
        }
    }
    protected void ddlExceptionAccount_SelectedIndexChanged(object sender, EventArgs e)
    {
        fillddlLOB();
    }

    private void fillddlLOB()
    {
        string AccountId = ddlExceptionAccount.SelectedValue.ToString();

        string strSQL = "[WFMP].[fillAccountLOB]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@Account", AccountId);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlExceptionLOB.DataSource = dt;
        ddlExceptionLOB.DataTextField = "LOB";
        ddlExceptionLOB.DataValueField = "LOB";
        ddlExceptionLOB.DataBind();
    }

    private void fillKPI()
    {
        string strSQL = "[WFMP].[fillKPI]";
        SqlCommand cmd = new SqlCommand(strSQL);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlExceptionKPI.DataSource = dt;
        ddlExceptionKPI.DataTextField = "Metrics";
        ddlExceptionKPI.DataValueField = "Metrics";
        ddlExceptionKPI.DataBind();
    }


    private void fillMonth()
    {
        string strSQL = "[WFMP].[fillMonth]";
        SqlCommand cmd = new SqlCommand(strSQL);
        //cmd.Parameters.AddWithValue("@AccountName", Account);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlMonth.DataSource = dt;
        ddlMonth.DataTextField = "TextDescription";
        ddlMonth.DataValueField = "ID";
        ddlMonth.DataBind();
    }

    private void fillddlInterval()
    {
        string strSQL = "[WFMP].[fillInterval]";
        SqlCommand cmd = new SqlCommand(strSQL);
        //cmd.Parameters.AddWithValue("@AccountName", Account);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlFromInterval.DataSource = dt;
        ddlFromInterval.DataTextField = "Interval";
        ddlFromInterval.DataValueField = "TimePeriod";
        ddlFromInterval.DataBind();

        ddlToInterval.DataSource = dt;
        ddlToInterval.DataTextField = "Interval";
        ddlToInterval.DataValueField = "TimePeriod";
        ddlToInterval.DataBind();
    }

    //private void clearfields() {
    //    ddlInterval.ClearSelection();
    //    ddlAccount.ClearSelection();
    //    //ddlLOB.ClearSelection();
    //    lbSites.ClearSelection();
    //    txtIssue.Text = string.Empty;
    //    tbDate.Text = string.Empty;
    //    ddlIncident.ClearSelection();
    //    txtClientTicket.Text = string.Empty;
    //    txtSitelTicket.Text = string.Empty;
    //    AttachIssueMail.Attributes.Clear();
    //    fillddlLOB();
    //}
    //protected void btnDiscardEsc_Click(object sender, EventArgs e)
    //{
    //    clearfields();
    //}

    private void fillgvPendingLog()
    {
        strSQL = "[WFMPMS].[GetPendingExceptionTracker]";
        SqlCommand cmd = new SqlCommand(strSQL);
        DataTable dt3 = my.GetDataTableViaProcedure(ref cmd);
        string[] filePaths = Directory.GetFiles(Server.MapPath("Sitel/mails/"));
        //string[] filePaths1 = Directory.GetFiles("Sitel/mails/");
        List<ListItem> files = new List<ListItem>();

        foreach (string filePath in filePaths)
        {

            files.Add(new ListItem(Path.GetFileName(filePath), filePath));

        }
        gvPendingLog.DataSource = dt3; 
        gvPendingLog.DataBind();
        
    }



    protected void cbDate_CheckedChanged(object sender, EventArgs e)
    {
        if (cbDate.Checked)
            tbDate.Enabled = true;
        else
            tbDate.Enabled = false;
    }

    protected void cbInterval_CheckedChanged(object sender, EventArgs e)
    {
        if (cbInterval.Checked)
        {
            ddlFromInterval.Enabled = true;
            ddlToInterval.Enabled = true;
        }
        else
        {
            ddlFromInterval.Enabled = false;
            ddlToInterval.Enabled = false;
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertExceptionTracker]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;

        DateTime Date;
        SqlDateTime sqldatenull;
        sqldatenull = SqlDateTime.Null;
        //if (!DateTime.TryParse(tbDate.Text.ToString(), out Date)) { tbDate.Text = "Not a Date"; }
        string AccountId = ddlExceptionAccount.SelectedItem.Value.ToString();
        string AccountName = ddlExceptionAccount.SelectedItem.Text.ToString();
        string lob = ddlExceptionLOB.SelectedItem.Value.ToString();
        string kpi = ddlExceptionKPI.SelectedItem.Value.ToString();
        string month = ddlMonth.SelectedItem.Value.ToString();
        if (cbDate.Checked)
        {
            if (DateTime.TryParse(tbDate.Text, out Date))
            {
                cmd.Parameters.AddWithValue("@Date", Date);
            }
        }
        else
        {
            //DateTime datee = default(DateTime);
            cmd.Parameters.AddWithValue("@Date", sqldatenull);
        }
        string FromInterval;
        string ToInterval;
        if (cbInterval.Checked)
        {
            FromInterval = ddlFromInterval.SelectedItem.Value.ToString();
            ToInterval = ddlToInterval.SelectedItem.Value.ToString();
            cmd.Parameters.AddWithValue("@FromInterval", Convert.ToDateTime(FromInterval));
            cmd.Parameters.AddWithValue("@ToInterval", Convert.ToDateTime(ToInterval));
        }
        else
        {
            FromInterval = null;
            ToInterval = null;
            cmd.Parameters.AddWithValue("@FromInterval", sqldatenull);
            cmd.Parameters.AddWithValue("@ToInterval", sqldatenull);
        }
        // string folderPath = Server.MapPath("~/Sitel/mails/");
        string fileName = Path.GetFileName(AttachExceptionMail.FileName);
        //string filename1 = fileName.Replace(" ", String.Empty);
        // AttachExceptionMail.SaveAs(folderPath + Server.HtmlEncode(Path.GetFileName(AttachExceptionMail.FileName)));
        string Attachment = "Sitel/mails/" + fileName;
        string notes = txtException.Text.ToString();
        cmd.Parameters.AddWithValue("@AccountId", AccountId);
        cmd.Parameters.AddWithValue("@Account", AccountName);
        cmd.Parameters.AddWithValue("@LOB", lob);
        cmd.Parameters.AddWithValue("@KPI", kpi);
        cmd.Parameters.AddWithValue("@Month", Convert.ToInt32(month));
        cmd.Parameters.AddWithValue("@Attachment", Attachment);
        cmd.Parameters.AddWithValue("@Notes", notes);
        cmd.Parameters.AddWithValue("@RaisedBy", MyEmpID);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();

        Email.InitiatorEmpId = MyEmpID;//918031;
        Email.RecipientsEmpId = 798904.ToString();//931040.ToString();
        //Email.BCCsEmpId = 918031.ToString();
        //Email.CCsEmpId = MyEmpID.ToString();
        Email.Subject = "Exception raised";
        Email.Body = "<strong>Hi </strong> Chetan,";
        Email.Body += "<P>" + dtEmp.Rows[0]["First_Name"].ToString() + dtEmp.Rows[0]["Last_Name"].ToString() + " has raised exception for account:" + AccountName + ", LOB:" + lob + ", KPI:" + kpi + " for reason '" + notes + " on " + DateTime.Now + ". <p>";
        Email.Body += "<p>Please action on dashboard on <a href='http://iaccess/PACMAN//ExceptionTracker.aspx'>Exception Tracker page</a> .<p>";
        //Email.Attachment = Attachment;
        Email.Send();

        clearfields();
        fillgvPendingLog();
    }
    private void clearfields()
    {
        ddlExceptionAccount.ClearSelection();
        ddlExceptionLOB.ClearSelection();
        ddlExceptionKPI.ClearSelection();
        ddlMonth.ClearSelection();
        tbDate.Text = string.Empty;
        ddlFromInterval.ClearSelection();
        ddlToInterval.ClearSelection();
        cbDate.Checked = false;
        cbInterval.Checked = false;
        AttachExceptionMail.Attributes.Clear();
        txtException.Text = string.Empty;
    }

    protected void gvPendingLog_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        GridView gv = (GridView)sender;
        GridViewRow gvr = (GridViewRow)e.Row;
        if (gvr.RowIndex >= 0)// && e.Row.RowIndex == gv.EditIndex
        {
            int status;
            Button btnA = (Button)gvr.FindControlRecursive("btn_Approve");
            Button btnD = (Button)gvr.FindControlRecursive("btn_Decline");
            Button btnC = (Button)gvr.FindControlRecursive("btn_Cancel");

            if (Convert.ToInt32(dtEmp.Rows[0]["LevelIDnumber"].ToString()) <= 65)
            {

                btnA.Enabled = true;
                btnD.Enabled = true;
            }
            else
            {
                btnD.Enabled = false;
                btnA.Enabled = false;
            }

            string stat = gvr.Cells[15].Text.ToString();
            if (stat == "&nbsp;")
            {
                status = 10;
            }
            else
            {
                status = Convert.ToInt32(stat);
            }
            //int dt = Convert.ToInt32(date);
            //DateTime canceldate = Convert.ToDateTime(date);
            //from_date
            //string fdate = gvr.Cells[0].Text.ToString();
            //DateTime fromdate = Convert.ToDateTime(fdate);
            //DateTime today = DateTime.Today;
            if (status == 1)//
            {
                //btn.CssClass = "btn btn-sm btn-danger disabled";
                gvr.Cells[15].Text = "Approved";
                btnC.Enabled = false;
                btnD.Enabled = false;
                btnA.Enabled = false;
            }
            else if (status == 0)
            {
                gvr.Cells[15].Text = "Declined";
                btnC.Enabled = false;
                btnD.Enabled = false;
                btnA.Enabled = false;
            }
            else if (status == 2)
            {
                gvr.Cells[15].Text = "Cancelled";
                btnC.Enabled = false;
                btnD.Enabled = false;
                btnA.Enabled = false;
            }

        }
    }

    protected void lbDownload_Click(object sender, EventArgs e)
    {
        string filePath = (sender as LinkButton).CommandArgument;

        Response.ContentType = ContentType;

        Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(filePath));

        Response.WriteFile(filePath);

        Response.End();
    }

    protected void btn_Approve_Click(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        GridViewRow row = (GridViewRow)btn.NamingContainer;

        string ExceptionID = row.Cells[0].Text.ToString();
        int EmployeeID = Convert.ToInt32(row.Cells[16].Text.ToString());
        string AccountName = row.Cells[1].Text.ToString();
        string lob = row.Cells[2].Text.ToString();
        string kpi = row.Cells[3].Text.ToString();
        string notes = row.Cells[4].Text.ToString();
        int status = 1;

        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[UpdateExceptionTracker]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@ID", ExceptionID);
        cmd.Parameters.AddWithValue("@ActionedBy", MyEmpID);
        cmd.Parameters.AddWithValue("@Status", status);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        row.Cells[12].Enabled = false;
        row.Cells[13].Enabled = false;
        row.Cells[14].Enabled = false;
        fillgvPendingLog();

        Email.InitiatorEmpId = 798904;// 918031;
        Email.RecipientsEmpId = EmployeeID.ToString(); //931040.ToString();//
        //Email.BCCsEmpId = 918031.ToString();
        //Email.CCsEmpId = MyEmpID.ToString();
        Email.Subject = "Exception approved";
        Email.Body = "<strong>Hi, </strong>";
        Email.Body += "<p>Exception approved for ACCOUNT:" + AccountName + ", LOB:" + lob + ", KPI:" + kpi + " for reason '" + notes + " on " + DateTime.Now + "<p>";
        //Email.Attachment = Attachment;
        Email.Send();
    }

    protected void btn_Decline_Click(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        GridViewRow row = (GridViewRow)btn.NamingContainer;

        string ExceptionID = row.Cells[0].Text.ToString();
        int EmployeeID = Convert.ToInt32(row.Cells[16].Text.ToString());
        string AccountName = row.Cells[1].Text.ToString();
        string lob = row.Cells[2].Text.ToString();
        string kpi = row.Cells[3].Text.ToString();
        string notes = row.Cells[4].Text.ToString();
        int status = 0;

        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[UpdateExceptionTracker]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@ID", ExceptionID);
        cmd.Parameters.AddWithValue("@ActionedBy", MyEmpID);
        cmd.Parameters.AddWithValue("@Status", status);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        row.Cells[12].Enabled = false;
        row.Cells[13].Enabled = false;
        row.Cells[14].Enabled = false;
        fillgvPendingLog();

        Email.InitiatorEmpId = 798904;// 918031;
        Email.RecipientsEmpId = EmployeeID.ToString(); //931040.ToString();//
        //Email.BCCsEmpId = 918031.ToString();
        //Email.CCsEmpId = MyEmpID.ToString();
        Email.Subject = "Exception declined";
        Email.Body = "Exception declined for ACCOUNT:" + AccountName + ", LOB:" + lob + ", KPI:" + kpi + " for reason '" + notes + " on " + DateTime.Now;
        //Email.Attachment = Attachment;
        Email.Send();
    }

    protected void btn_Cancel_Click(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        GridViewRow row = (GridViewRow)btn.NamingContainer;

        string ExceptionID = row.Cells[0].Text.ToString();
        int status = 2;

        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[UpdateExceptionTracker]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@ID", ExceptionID);
        cmd.Parameters.AddWithValue("@ActionedBy", MyEmpID);
        cmd.Parameters.AddWithValue("@Status", status);
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        row.Cells[12].Enabled = false;
        row.Cells[13].Enabled = false;
        row.Cells[14].Enabled = false;
        fillgvPendingLog();
    }

    protected void gv_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;
        if (gv.Rows.Count > 0)
        {
            gv.UseAccessibleHeader = true;
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
            gv.HeaderStyle.BorderStyle = BorderStyle.None;
            gv.BorderStyle = BorderStyle.None;
            gv.BorderWidth = Unit.Pixel(1);
            gv.FooterRow.TableSection = TableRowSection.TableFooter;
        }
    }
}