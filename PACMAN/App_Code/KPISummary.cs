using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for KPISummary
/// </summary>
public class KPISummary
{
    public string AccountId { get; set; }
    public string Account { get; set; }
    public string PrimaryKPI { get; set; }
    public decimal PrimaryKPITarget { get; set; }
    public decimal Rating { get; set; }
    public int Occurence { get; set; }    
    public int RatingxOccurence { get; set; }
    public string Calculation { get; set; }
    public KPISummary()
    {
        //
        // TODO: Add constructor logic here
        //
    }
}