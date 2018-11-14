using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
public partial class ExceptionApproval : System.Web.UI.Page
{
    DataTable dt;
    Helper my;
    string strSQL;
    int MyEmpID;
    string xFirst_Name = "";
    string xLast_Name = "";
    public DataTable dtLeaveLog { get; set; }
    public string rowFilter { get; set; }
    public bool isFiltered { get; set; }
    EmailSender Email = new EmailSender();
    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();
        try
        {
            dt = (DataTable)Session["dtEmp"];
            if (dt.Rows.Count <= 0)
            {
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
            else
            {
                MyEmpID = Convert.ToInt32(dt.Rows[0]["Employee_Id"].ToString());
                xFirst_Name = Convert.ToString(dt.Rows[0]["First_Name"].ToString());
                xLast_Name = Convert.ToString(dt.Rows[0]["Last_Name"].ToString());
                Session["MyEmpID"] = MyEmpID;
                Session["xFirst_Name"] = xFirst_Name;
                Session["xLast_Name"] = xLast_Name;
            }
        }
        catch (Exception Ex)
        {
            Response.Write(Ex.Message);
            string redirect2URL = "index.aspx";
            if (ViewState["PreviousPageUrl"] != null)
            {
                redirect2URL = ViewState["PreviousPageUrl"].ToString();
            }
            else
            {
                ViewState["PreviousPageUrl"] = Page.Request.Url.ToString();
            }
            Response.Redirect(redirect2URL, false);
        }

        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "ExceptionApproval";
        if (!IsPostBack)
        {
            //fillddlRepManager();
        }
    }


    //public class Menu
    //{
    //    public int ID { get; set; }
    //    public string Text { get; set; }
    //    public string URL { get; set; }
    //    public string Link { get; set; }
    //    public int? parentId { get; set; }
    //    public bool isActive { get; set; }
    //    public List<Menu> List { get; set; }
    //}

    //[WebMethod]
    //public static string xGetMenuList()
    //{
    //    Helper my = new Helper();
    //    var list = new List<Menu>();

    //    string strSQL = "COMMON..GetMenu";
    //    SqlCommand cmd = new SqlCommand(strSQL);

    //    DataSet ds = my.GetDataSetViaProcedure(ref cmd);
    //    string xPID = "0";
    //    foreach (DataRow dr in ds.Tables[0].Rows)
    //    {
    //        xPID = xPID + "," + dr["ID"].ToString();
    //        var menu = new Menu
    //        {
    //            ID = Convert.ToInt32(dr["ID"]),
    //            Text = dr["Text"].ToString(),
    //            URL = dr["URL"].ToString(),
    //            Link = dr["Link"].ToString(),
    //            parentId = dr["parentId"] != DBNull.Value ? Convert.ToInt32(dr["parentId"]) : (int?)null,
    //            isActive = Convert.ToBoolean(dr["isActive"])
    //        };
    //        list.Add(menu);
    //    }

    //    var mainList = GetMenuTree(list, 0);

    //    //int xMin = Convert.ToInt32(ds.Tables[1].Rows[0]["xMin"]);
    //    //int xMax = Convert.ToInt32(ds.Tables[1].Rows[0]["xMax"]);

    //    //foreach (var xIDc in xPID.Split(','))
    //    //{
    //    //    if (xIDc != "0" && xIDc.Length > 0)
    //    //    {
    //    //        var listToAdd = GetMenuTree(list, Convert.ToInt32(xIDc));
    //    //        if (listToAdd.Count > 0)
    //    //        {
    //    //            mainList.AddRange(listToAdd);
    //    //        }
    //    //    }
    //    //}

    //    var json = JsonConvert.SerializeObject(mainList);
    //    return json;
    //}

    //List<Menu> xlist = new List<Menu>();
    //private static List<Menu> GetMenuTree(List<Menu> list, int? parent)
    //{

    //    return list.Where(x => x.parentId == parent).Select(x => new Menu
    //    {
    //        ID = x.ID,
    //        Text = x.Text,
    //        URL = x.URL,
    //        Link = x.Link,
    //        parentId = x.parentId,
    //        isActive = x.isActive,
    //        List = GetMenuTree(list, x.ID)
    //    }).ToList();

    //}



    //public class GetRepManager
    //{
    //    public string EmpCode { get; set; }
    //    public string Name { get; set; }
    //}

    [WebMethod]
    public static List<GetReviewPeriod> GetAllReviewPeriod()
    {
        string EMPCODE = Convert.ToString(HttpContext.Current.Session["MyEmpID"]);
        Helper my = new Helper();
        string strSQL = "WFMPMS.GetPacmanCycleforPacmanDiscussion_g";
        SqlCommand cmd = new SqlCommand(strSQL);

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        List<GetReviewPeriod> myJSON = new List<GetReviewPeriod>();
        myJSON = (from DataRow dr in dt.Rows
                  select new GetReviewPeriod()
                  {
                      PeriodID = dr["PeriodID"].ToString(),
                      Period = dr["Period"].ToString()
                  }).ToList();

        return myJSON;
    }

    public class GetReviewPeriod
    {
        public string PeriodID { get; set; }
        public string Period { get; set; }

    }

    [WebMethod]
    public static List<GetPendingAccount> GetPendingAccountList(string Month)
    {
        var EMPCODE = Convert.ToString(HttpContext.Current.Session["MyEmpID"]);
        // DropDownList v = (DropDownList)PageExtensionMethods.FindControlRecursive(Master, "ddlReviewPeriod");
        //string Month = v.SelectedIndex.ToString();
        Helper my = new Helper();
        string strSQL = "[WFMPMS].[GetPendingAccountExceptionList]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", EMPCODE);// Convert.ToInt32(MyEmpID.ToString()));
        cmd.Parameters.AddWithValue("@Month", Month);
        DataTable dt2 = my.GetDataTableViaProcedure(ref cmd);
        List<GetPendingAccount> myJSON = new List<GetPendingAccount>();
        myJSON = (from DataRow dr in dt2.Rows
                  select new GetPendingAccount()
                  {
                      AccountID = dr["AccountID"].ToString(),
                      Account = dr["Account"].ToString()
                  }).ToList();

        return myJSON;
    }

    public class GetPendingAccount
    {
        public string AccountID { get; set; }
        public string Account { get; set; }
    }


    [WebMethod]
    public static string GetList(string Month, string Account)
    {
        var EMPCODE = Convert.ToString(HttpContext.Current.Session["MyEmpID"]);
        Helper my = new Helper();
        string strSQL = "[WFMPMS].[GetPendingExceptionTrackerforApproval]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", EMPCODE);
        cmd.Parameters.AddWithValue("@Month", Month);
        cmd.Parameters.AddWithValue("@AccountID", Account);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        //DataSet ds = new DataSet();
        //ds.Tables.Add(dt);
        //string daresult = DataSetToJSON(ds);
        //return daresult;
        return my.DataTableToJSONWithJSONNet(dt);
    }

    [WebMethod]
    public static string UpdateException(string ID, string Status, string RaisedBy, string Account, string LOB_A, string KPI, string notes)
    {
        var EMPCODE = Convert.ToString(HttpContext.Current.Session["MyEmpID"]);
        Helper my = new Helper();
        string strSQL = "[WFMPMS].[UpdateExceptionTracker]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@ID", ID);
        cmd.Parameters.AddWithValue("@ActionedBy", EMPCODE);
        cmd.Parameters.AddWithValue("@Status", Status);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        //DataSet ds = new DataSet();
        //ds.Tables.Add(dt);
        //string daresult = DataSetToJSON(ds);
        //return daresult;

        EmailSender Email = new EmailSender();
        Email.InitiatorEmpId = Convert.ToInt32(EMPCODE);// 918031;
        Email.RecipientsEmpId = RaisedBy.ToString(); //931040.ToString();//
        //Email.BCCsEmpId = 918031.ToString();
        //Email.CCsEmpId = MyEmpID.ToString();
        //Email.Subject = "Exception approved";
        Email.Body = "<strong>Hi, </strong>";
        if (Convert.ToInt32(Status) == 1)
        {
            Email.Subject = "Exception approved";
            Email.Body += "<p>Exception approved for ACCOUNT:" + Account + ", LOB:" + LOB_A + ", KPI:" + KPI + " for reason '" + notes + " on " + DateTime.Now + "<p>";
        }
        else if (Convert.ToInt32(Status) == 0)
        {
            Email.Subject = "Exception declined";
            Email.Body += "<p>Exception declined for ACCOUNT:" + Account + ", LOB:" + LOB_A + ", KPI:" + KPI + " for reason '" + notes + " on " + DateTime.Now + "<p>";
        }
        //Email.Attachment = Attachment;
        //Email.Send();

        return my.DataTableToJSONWithJSONNet(dt);


    }
}

