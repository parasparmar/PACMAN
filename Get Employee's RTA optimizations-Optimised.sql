Use CWFM_Umang

Declare @Employee_ID int
Declare @FromDate Date 
Declare @ToDate Date
Declare @PrimaryClientID nvarchar(50)
Declare @LevelId int
Declare @Scale int

Set @Employee_ID = 803471
Set @FromDate = '20170820'
Set @ToDate = '20170831'
Set @PrimaryClientID = '511TOT1'
Set @Scale = 5

----Set @LevelId = Select 

select Distinct
	A.Employee_ID
	, A.Name, A.Account, A.LOB
	, Convert(varchar,A.Date,106) as Date
	--, A.QStart
	--,A.QEnd	
	, A.TimePeriod
	, A.TargetSL
	, A.ProjectedSL
	, A.ActualSL
	, Case when TargetSL < ProjectedSL and ActualSL between TargetSL and ProjectedSL
	then Round(5-((ActualSL - TargetSL) / ((ProjectedSL - TargetSL)/@Scale)),4) 
		 
	when TargetSL > ProjectedSL and ActualSL between ProjectedSL and TargetSL
	then Round(((TargetSL - ActualSL) / ((TargetSL - ProjectedSL )/@Scale)),4) 

	when ActualSL = ProjectedSL then 0
	else 0 end as Rating
			

 from (
		Select Distinct
			A.Employee_ID, A.First_Name+' '+ A.Middle_Name +' '+ A.Last_Name as Name
			, B.Account
			, C.LOB		
			, C.SkillId	
			, D.Date
			--, F.[StartTime] as RosterStarts
			--, F.[EndTime] as RosterEnds
			--, Dateadd(hh,H.IST,F.[StartTime]) as MyIntervalStarts
			--, Dateadd(hh,H.IST,F.[EndTime]) as MyIntervalEnds
			--, M.QStart
			--, M.QEnd
			, D.TimePeriod			
			, 100* G.PrimaryKPITarget As TargetSL	    			
			, L.RevServiceLevel as ProjectedSL			
			, Round(100*sum(D.AcceptableCalls) / sum(D.CallsOffered),2) as ActualSL

		from [WFMP].[tblMaster] A
			inner join [WFMPMS].[tblEmp2Account] B on A.Employee_ID = B.EmpCode
			inner join [WFMPMS].[tblAcc2LOB] C on C.AccountID = B.PrimaryClientID
			inner join [WFMPMS].[tblBO] D on C.AccountID = D.PrimaryClientID and C.SkillId = D.SplitID
			inner join [WFMP].[RosterMst] E on E.EmpCode = B.EmpCode
			inner join [WFMPMS].[tblCalculations] G on G.ClientID = B.PrimaryClientID
			inner join [WFMPMS].[tblTimeZones] H on H.TimeZone = G.ReportingTimeZone
			inner join [WFMP].[tblShiftCode] F on F.[ShiftID] = E.[ShiftID] and E.rDate = D.Date 
			and D.TimePeriod between Dateadd(hh,H.IST,F.[StartTime]) and Dateadd(hh,H.IST,F.[EndTime])
			inner join [WFMPMS].[tblLOB2CT] I on I.LOB = C.LOB
			inner join [WFMPMS].[tblForecastCallsBO] J on J.[QueueName] = I.CT and D.Date = J.Date and D.TimePeriod = J.TimePeriod
			inner join [CWFM_Umang].[WFMPMS].[tblLOB2CT] K on C.AccountID = K.AccountID and C.LOB = K.LOB 
			inner join [CWFM_Umang].[WFMPMS].[tblIEX] L on L.CT like '%'+K.CT 
			and L.Date = D.Date and L.Time = D.TimePeriod
			inner join [WFMPMS].[tblHOOP] M on M.AccountID = D.PrimaryClientID 
			and Datepart("WEEKDAY",D.Date) = M.WeekDay and M.TimeZone = G.ReportingTimeZone 
			and D.TimePeriod between M.QStart and M.QEnd

		where 1 = 1 
			and A.Employee_ID = @Employee_ID ----803471
			and D.Date between @FromDate and @ToDate ---'20170820'
			and B.PrimaryClientID = @PrimaryClientID ----'511TOT1'	
			and D.CallsOffered > 0

			group by 	
			A.Employee_ID, A.First_Name+' '+ A.Middle_Name +' '+ A.Last_Name 
			, B.Account
			, C.LOB		
			, C.SkillId	
			, D.Date
			, F.[StartTime]
			, F.[EndTime]
			, H.IST
			, D.TimePeriod
			, M.QStart
			, M.QEnd
			, G.PrimaryKPITarget 
			, D.CallsOffered
			, L.RevServiceLevel
			, D.AcceptableCalls
			
) A

