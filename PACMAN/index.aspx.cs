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

    string myID;
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Request.UrlReferrer != null)
        {
            ViewState["PreviousPageUrl"] = Request.UrlReferrer.ToString();
        }
        //myID = PageExtensionMethods.getMyWindowsID().ToString();
        //myID = "pbhat004"; //Planner Puja Bhatia
        //myID = "vchoh001"; //RTA Vinod Chauhan
        //myID = "slall002"; //Manager Sandeep Lalla
        //myID = "jsing050"; //Scheduler Jagdeep.Singh@sitel.com

        myID = "akamb002"; //Planner Anil Kamble
        if (myID != "IDNotFound")
        {

            Helper my = new Helper();

            DataTable dt = my.GetData("WFMP.getEmployeeData '" + myID + "'");
            try
            {
                if (dt.Rows.Count > 0)
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
}