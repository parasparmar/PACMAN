using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Sql;
using System.Data.SqlClient;


public partial class EscalationsInitiatives : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    string strSQL;
    int MyEmpID;
    string reportee { get; set; }
    string pacmancycle { get; set; }

    EmailSender Email = new EmailSender();
    private DateTime StartDate { get; set; }
    private DateTime EndDate { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        //Page.Form.Attributes.Add("enctype", "multipart/form-data");
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
                MyEmpID = dtEmp.Rows[0]["Employee_Id"].ToString().ToInt32();
            }

        }
        catch (Exception Ex)
        {
            Response.Write(Ex.Message);
        }

        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Escalation & Initiatives";

        reportee = ddlSelectEmployee.SelectedItem.Value.ToString();
        if (Convert.ToInt32(reportee) == MyEmpID || Convert.ToInt32(reportee) == 0)
        {
            txtEscalation.Enabled = false;
            btnSaveEsc.Enabled = false;
            txtInitiative.Enabled = false;
            btnSaveIni.Enabled = false;
        }
        else
        {
            txtEscalation.Enabled = true;
            btnSaveEsc.Enabled = true;
            txtInitiative.Enabled = true;
            btnSaveIni.Enabled = true;
        }
        //txtEscalation.Enabled=false;
        //btnSaveEsc.Enabled = false;
        //txtInitiative.Enabled=false;
        //btnSaveIni.Enabled = false;


        if (!IsPostBack)
        {
            //MyEmpID = 923563;
            fillddlPacmanCycle();
            fillddlSelectEmployee();
            fillgvEscalationlog();
            fillgvInitiativelog();
            getTotalScore();
        }
    }


    private void fillddlPacmanCycle()
    {
        string emp;
        string empId;
        emp = ddlSelectEmployee.SelectedItem.Value.ToString();

        if (Convert.ToInt32(emp) == 0)
        { empId = MyEmpID.ToString(); }
        else
        { empId = emp; }

        //strSQL = "CWFM_UMANG.[WFMPMS].[GetPacmanCycle]";

        //SqlCommand cmd = new SqlCommand(strSQL);
        //cmd.Parameters.AddWithValue("@EmpCode", Convert.ToInt32(empId));
        //DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        //ddlPacmanCycle.DataSource = dt1;
        //ddlPacmanCycle.DataTextField = "TextDescription";
        //ddlPacmanCycle.DataValueField = "ID";
        //ddlPacmanCycle.DataBind();

        strSQL = "WFMPMS.GetPacmanCycleforPacmanDiscussion_g";

        SqlCommand cmd = new SqlCommand(strSQL);
        //cmd.Parameters.AddWithValue("@EmpCode", Convert.ToInt32(empId));
        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        ddlPacmanCycle.DataSource = dt1;
        ddlPacmanCycle.DataTextField = "Period";
        ddlPacmanCycle.DataValueField = "PeriodID";
        ddlPacmanCycle.DataBind();


        DropDownList v = (DropDownList)PageExtensionMethods.FindControlRecursive(Master, "ddlPacmanCycle");

        v.SelectedIndex = v.Items.IndexOf(v.Items.FindByValue(MyEmpID.ToString()));

    }

    private void fillddlSelectEmployee()
    {
        strSQL = "CWFM_UMANG.[WFMPMS].[GetEmpforFeedandEsc]";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", Convert.ToInt32(MyEmpID.ToString()));
        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        ddlSelectEmployee.DataSource = dt1;
        ddlSelectEmployee.DataTextField = "MgrName";
        ddlSelectEmployee.DataValueField = "MgrID";
        ddlSelectEmployee.DataBind();
        DropDownList v = (DropDownList)PageExtensionMethods.FindControlRecursive(Master, "ddlSelectEmployee");

        v.SelectedIndex = v.Items.IndexOf(v.Items.FindByValue(MyEmpID.ToString()));

    }

    private void fillgvEscalationlog()
    {
        reportee = ddlSelectEmployee.SelectedItem.Value.ToString();//int report = 835064;
        pacmancycle = ddlPacmanCycle.SelectedItem.Value.ToString();//int pc = 1;

        strSQL = "[WFMPMS].[GetEscalationLog]";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", Convert.ToInt32(reportee));
        cmd.Parameters.AddWithValue("@PacmanCycle", Convert.ToInt32(pacmancycle));
        cmd.Parameters.Add("@score", SqlDbType.Float);
        cmd.Parameters["@score"].Direction = ParameterDirection.Output;
        DataTable dt2 = my.GetDataTableViaProcedure(ref cmd);
        gvEscalationlog.DataSource = dt2;
        gvEscalationlog.DataBind();

        string scoreEsc = cmd.Parameters["@score"].Value.ToString();
        lblEscalationScoreTop.Text = scoreEsc;
        lblEscalationScoreBottom.Text = scoreEsc;
    }


    protected void lbDownload_Click(object sender, EventArgs e)
    {
        string filePath = (sender as LinkButton).CommandArgument;

        Response.ContentType = ContentType;

        Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(filePath));

        Response.WriteFile(filePath);

        Response.End();
    }

    private void fillgvInitiativelog()
    {
        reportee = ddlSelectEmployee.SelectedItem.Value.ToString();//int report = 835064;
        pacmancycle = ddlPacmanCycle.SelectedItem.Value.ToString();//int pc = 1;

        strSQL = "[WFMPMS].[GetInitiativeLog]";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", Convert.ToInt32(reportee));
        cmd.Parameters.AddWithValue("@PacmanCycle", Convert.ToInt32(pacmancycle));
        cmd.Parameters.Add("@points", SqlDbType.Float);
        cmd.Parameters["@points"].Direction = ParameterDirection.Output;
        DataTable dt3 = my.GetDataTableViaProcedure(ref cmd);
        gvInitiativeLog.DataSource = dt3;
        gvInitiativeLog.DataBind();

        string scoreIni = cmd.Parameters["@points"].Value.ToString();
        lblInitiativeScoreTop.Text = scoreIni;
        lblInitiativeScoreBottom.Text = scoreIni;
    }
    private void fillStartAndEndDates()
    {
        int PeriodID = Convert.ToInt32(ddlPacmanCycle.SelectedValue);
        string strSQL = "SELECT [FromDate],[ToDate] FROM [PMS].[PeriodMst] where [PeriodID] =" + PeriodID;
        DataTable dt = my.GetData(strSQL);
        if (dt != null && dt.Rows.Count > 0)
        {
            StartDate = Convert.ToDateTime(dt.Rows[0]["FromDate"].ToString());
            EndDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());

        }
        else
        {
            StartDate = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1);
            EndDate = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 31);

        }

    }
    private void getTotalScore()
    {
        reportee = ddlSelectEmployee.SelectedItem.Value.ToString();//int reportee = 835064;
        pacmancycle = ddlPacmanCycle.SelectedItem.Value.ToString();//int pacmancycle = 6;
        fillStartAndEndDates();
        strSQL = "[WFMPMS].[GetEscalationInitiativeScore_g]";
        SqlConnection cn = new SqlConnection(my.getConnectionString());
        cn.Open();
        SqlCommand cmd = new SqlCommand(strSQL, cn);
        cmd.Parameters.AddWithValue("@EmpCode", Convert.ToInt32(reportee));
        //cmd.Parameters.AddWithValue("@PacmanCycle", Convert.ToInt32(pacmancycle));
        cmd.Parameters.AddWithValue("@StartDate", StartDate);
        cmd.Parameters.AddWithValue("@EndDate", EndDate);
        //cmd.Parameters.Add("@total", SqlDbType.Float);
        //cmd.Parameters["@total"].Direction = ParameterDirection.Output;
        cmd.CommandType = CommandType.StoredProcedure;
        //string total = cmd.ExecuteScalar().ToString();
        //cmd.ExecuteNonQuery();
        //string scoretotal = cmd.Parameters["@total"].Value.ToString();
        DataTable dt = my.GetData(ref cmd);
        //gv.DataSource = dt;
        //gv.DataBind();

        DataRow[] drs = dt.Select("Account = 'Grand Total'");
        if (drs.Length == 1)
            foreach (DataRow r in drs)
            {
                lblTotalScore.Text = r["Rating"].ToString();
            }
        //lblTotalScore.Text = scoretotal;

        //string total1 = 
        //DataTable dt3 = my.GetDataTableViaProcedure(ref cmd);
        //gvInitiativeLog.DataSource = dt3;
        //gvInitiativeLog.DataBind();
        cn.Close();


    }

    protected void ddlPacmanCycle_SelectedIndexChanged(object sender, EventArgs e)
    {
        fillgvEscalationlog();
        fillgvInitiativelog();
        getTotalScore();
    }

    protected void btnSaveEsc_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMPMS].[InsertEscalationInitiative]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;

        string folderPath = Server.MapPath("~/Sitel/mails/");

        //string fileName1 = FileUploadAttachMailEsc.FileName;
        string fileName = Path.GetFileName(FileUploadAttachMailEsc.FileName);

        FileUploadAttachMailEsc.SaveAs(folderPath + Path.GetFileName(FileUploadAttachMailEsc.FileName));

        string Attachment = "Sitel/mails/" + fileName;

        //if (FileUploadAttachMailEsc.HasFile)
        //{
        //    try
        //    {
        //        //string path="Sitel / mails /";
        //        string filename = Path.GetFileName(FileUploadAttachMailEsc.FileName);
        //        FileUploadAttachMailEsc.SaveAs(Server.MapPath("~/Sitel/mails/") + filename);
        //        //StatusLabel.Text = "Upload status: File uploaded!";
        //    }
        //    catch (Exception ex)
        //    {
        //        //StatusLabel.Text = "Upload status: The file could not be uploaded. The following error occured: " + ex.Message;
        //        Response.Write(ex.Message);
        //    }
        //}


        MyEmpID = dtEmp.Rows[0]["Employee_Id"].ToString().ToInt32();
        reportee = ddlSelectEmployee.SelectedItem.Value.ToString();
        string type = "Escalation";
        string description = txtEscalation.Text.ToString();
        //string attachment = 
        pacmancycle = ddlPacmanCycle.SelectedItem.Value.ToString();
        string category = rbEscalation.Text.ToString();

        cmd.Parameters.AddWithValue("@EmpCode", Convert.ToInt32(reportee));
        cmd.Parameters.AddWithValue("@Type", type);
        cmd.Parameters.AddWithValue("@Category", category);
        cmd.Parameters.AddWithValue("@Description", description);
        cmd.Parameters.AddWithValue("@Attachment", Attachment);
        cmd.Parameters.AddWithValue("@ActionBy", MyEmpID);
        cmd.Parameters.AddWithValue("@PacmanCycle", Convert.ToInt32(pacmancycle));
        cmd.Parameters.Add("@stop", SqlDbType.Int);
        cmd.Parameters["@stop"].Direction = ParameterDirection.Output;
        cmd.Connection = con;

        cmd.ExecuteNonQuery();
        string decider = cmd.Parameters["@stop"].Value.ToString();
        con.Close();
        if (Convert.ToInt32(decider) == 1)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", "toastr.warning('Cannot issue Escalation for past pacman cycle.')", true);
        }
        fillgvEscalationlog();
        getTotalScore();

        Email.InitiatorEmpId = MyEmpID;//918031;
        Email.RecipientsEmpId = reportee;//931040.ToString();
        //Email.BCCsEmpId = 918031.ToString();
        Email.CCsEmpId = MyEmpID.ToString();
        Email.Subject = "Escalation raised";
        Email.Body = "<strong>Hi, </strong>";
        Email.Body += "<P>" + dtEmp.Rows[0]["First_Name"].ToString() + dtEmp.Rows[0]["Last_Name"].ToString() + " has raised escalation <i>" + description + "</i> against you on " + DateTime.Now + "<p>";
        Email.Body += "<p>Please visit dashboard on <a href='http://iaccess/TA//EscalationsInitiatives.aspx'>Escalations and Initiatives page</a> .<p>";
        //Email.Attachment = Attachment;
        Email.Send();
        clearfields();
    }

    protected void btnSaveIni_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "CWFM_UMANG.[WFMPMS].[InsertEscalationInitiative]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;

        MyEmpID = dtEmp.Rows[0]["Employee_Id"].ToString().ToInt32();
        reportee = ddlSelectEmployee.SelectedItem.Value.ToString();
        string type = "Initiative";
        string description = txtInitiative.Text.ToString();
        pacmancycle = ddlPacmanCycle.SelectedItem.Value.ToString();
        string category = rbInitiative.Text.ToString();

        string folderPath = Server.MapPath("~/Sitel/mails/");
        string fileName = Path.GetFileName(FileUploadAttachMailIni.FileName);
        FileUploadAttachMailIni.SaveAs(folderPath + Path.GetFileName(FileUploadAttachMailIni.FileName));
        //string Attachment = Server.MapPath("~/Sitel/mails/") + fileName;
        string Attachment = "Sitel/mails/" + fileName;

        cmd.Parameters.AddWithValue("@EmpCode", Convert.ToInt32(reportee));
        cmd.Parameters.AddWithValue("@Type", type);
        cmd.Parameters.AddWithValue("@Category", category);
        cmd.Parameters.AddWithValue("@Description", description);
        cmd.Parameters.AddWithValue("@Attachment", Attachment);
        cmd.Parameters.AddWithValue("@ActionBy", MyEmpID);
        cmd.Parameters.AddWithValue("@PacmanCycle", Convert.ToInt32(pacmancycle));
        cmd.Parameters.Add("@stop", SqlDbType.Int);
        cmd.Parameters["@stop"].Direction = ParameterDirection.Output;
        cmd.Connection = con;

        cmd.ExecuteNonQuery();
        string decider = cmd.Parameters["@stop"].Value.ToString();
        con.Close();
        if (Convert.ToInt32(decider) == 1)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", "toastr.warning('Cannot issue Initiative for past pacman cycle.')", true);
        }
        fillgvInitiativelog();
        getTotalScore();

        Email.InitiatorEmpId = MyEmpID;//918031;
        Email.RecipientsEmpId = reportee;//931040.ToString();
        //Email.BCCsEmpId = 918031.ToString();
        Email.CCsEmpId = MyEmpID.ToString();
        Email.Subject = "Initiave Recorded";
        Email.Body = "<strong>Hi, </strong>";
        Email.Body += "<P>" + dtEmp.Rows[0]["First_Name"].ToString() + dtEmp.Rows[0]["Last_Name"].ToString() + " has recorded your initiative '" + description + "' on" + DateTime.Now + "<p>";
        Email.Body += "<p>Please visit dashboard on <a href='http://iaccess/PACMAN//EscalationsInitiatives.aspx'>Escalations and Initiatives page</a> .<p>";
        //Email.Attachment = Attachment;
        Email.Send();

        clearfields();
    }

    private void clearfields()
    {
        //ddl_leave_dropdown.ClearSelection();
        txtEscalation.Text = string.Empty;//.InnerText 
        rbEscalation.ClearSelection();
        txtInitiative.Text = string.Empty;
        rbInitiative.ClearSelection();
        //gvLeaveDetails.DataSource = null;
        //gvLeaveDetails.DataBind();
    }

    protected void ddlSelectEmployee_SelectedIndexChanged(object sender, EventArgs e)
    {
        fillddlPacmanCycle();
        fillgvEscalationlog();
        fillgvInitiativelog();
        getTotalScore();

        reportee = ddlSelectEmployee.SelectedItem.Value.ToString();
        if (Convert.ToInt32(reportee) == MyEmpID)
        {
            txtEscalation.Enabled = false;
            btnSaveEsc.Enabled = false;
            txtInitiative.Enabled = false;
            btnSaveIni.Enabled = false;
        }
        else
        {
            txtEscalation.Enabled = true;
            btnSaveEsc.Enabled = true;
            txtInitiative.Enabled = true;
            btnSaveIni.Enabled = true;
        }
    }

    protected void btnInDiscard_Click(object sender, EventArgs e)
    {
        txtInitiative.Text = string.Empty;
        rbInitiative.ClearSelection();
    }
    protected void btnDiscardEsc_Click(object sender, EventArgs e)
    {
        txtEscalation.Text = string.Empty;//.InnerText 
        rbEscalation.ClearSelection();
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