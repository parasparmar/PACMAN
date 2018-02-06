﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Sql;

public partial class index : System.Web.UI.Page
{

    private string myID { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.UrlReferrer != null)
        {
            ViewState["PreviousPageUrl"] = Request.UrlReferrer.ToString();
        }
        
        if (Request.QueryString["q"] != null)
        {
            string skillset = Request.QueryString["q"].ToString();
            myID = getMyImpersonatorsNTID(skillset);
            RedirectBasedOnNTNameLookup(myID);
        }
        else
        {
            myID = PageExtensionMethods.getMyWindowsID().ToString();
            RedirectBasedOnNTNameLookup(myID);
        }
        
    }

    private void RedirectBasedOnNTNameLookup(string myID)
    {
        Helper my = new Helper();
        DataTable dt = new DataTable();
        if (myID != "IDNotFound")
        {
            myID = "nchan016"; //RTA Vinod Chauhan
            SqlCommand cmd = new SqlCommand("WFMP.getEmployeeData");
            cmd.Parameters.AddWithValue("@NT_ID", myID);
            
            try
            {
                dt = my.GetDataTableViaProcedure(ref cmd);
                if (dt != null && dt.Rows.Count > 0)
                {

                    Session["dtEmp"] = dt;
                    Response.Redirect("pacman.aspx", false);
                }
                else
                {
                    // Every page in the application will use the session 'myID' as the NTName of the unauthorized user.
                    Session["myID"] = myID;
                    Response.Redirect("lockscreen.aspx", false);
                }
            }
            catch (Exception Ex)
            {
                Response.Write(Ex.Message);
            }
        }
        else
        {
            Response.Redirect("lockscreen.aspx", false);
        }

        
    }

    private DataTable getSkillsetImpersonator()
    {
        Helper my = new Helper();
        string strSQL = "Select distinct  A.Skillset from [WFMPMS].[tblDsgn2KPIWtg] A ";
        strSQL += " where A.SkillsetId <> 5 ";
        strSQL += " union select distinct A.Skillset + '-Manager' as Skillset from[WFMPMS].[tblDsgn2KPIWtg] A";
        strSQL += " where A.SkillsetId <> 5 ";
        DataTable dt = my.GetData(strSQL);
        return dt;

    }

    private string getMyImpersonatorsNTID(string QueryString)
    {
        switch (QueryString)
        {
            case "Analytics":
                myID = "pparm001";
                break;
            case "Analytics - Manager":
                myID = "gsing017";
                break;
            case "Planning":
                myID = "pbhat004"; //Planner Puja Bhatia
                                   //myID = "akamb002"; //Planner Anil Kamble
                break;
            case "Planning - Manager":

                break;
            case "RTA":
                myID = "vchoh001"; //RTA Vinod Chauhan
                break;
            case "RTA - Manager":
                myID = "slall002"; //Manager Sandeep Lalla
                break;
            case "Scheduling":
                myID = "jsing050"; //Scheduler Jagdeep.Singh@sitel.com
                break;
            case "Scheduling - Manager":
                myID = "slall002"; //Manager Sandeep Lalla
                break;
            default:
                myID = PageExtensionMethods.getMyWindowsID().ToString();
                break;
        }
        return myID;
    }
}