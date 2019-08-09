/*********************************************
 * OPL 12.6.3.0 Data
 * Author: pt428
 * Creation Date: 24 May 2018 at 11:23:58
 *********************************************/

//Termination criteria


execute {
	cplex.epgap=0;
	
	}


float temp;
execute {
	var before = new Date();
	temp = before.getTime();
}


//***********************************Define sets************************************
{string} Cell = ...;
{string} ConnectedCell = ...;
{string} NonConnectedCell = ...;
{string} GenTech = ...;
{string} TransLine = ...;
{string} Time = ...;
{string} AllTime = ...;
{string} Plant = ...;
{string} OneTimePlant = ...;
{string} ConnectedPlant = ...;
{string} VolatilePlant = ...;
{string} OffGridPlant = ...;
{string} ConnectedSolarPlant = ...;
{string} ConnectedNonSolarPlant = ...;
{string} Line = ...;
{string} NonExistLine = ...;
{string} ExistLine = ...;
{string} ConnectedPlantNotconnectedDistrict = ...;




range GenTechRange = 1..20;
range TransLineRange = 1..36;
range TimeRange = 1..5;
range AllTimeRange = 1..21;
range PlantRange = 1..49;
range CellXTime = 1..50;
range CellXTransLine = 1..360;
range PlantXTime = 1..245;
range ConnectedPlantXTime = 1..145;
range CellXPlant = 1..490;
range GenTechXPlant = 1..980;
range TransLineXTime = 1..180;
range NonExistLineXTime = 1..70;
range LineRange = 1..18;
range LineXTime = 1..90;
range LineXTransLine = 1..648;
range ConnectedPlantncDistrXLine = 1..288;




//***************************Define single parameters******************************
float TOMSh = ...; 
float eps_urbrur = ...;
float eps_reg = ...;
float eps_em = ...;
int indexPoint = ...;
float MaxVol = ...;
float PDemRt = ...;
float RM = ...;
float CLkV = ...;
float OGAddInv = ...;
float MaxShSol = ...;
float MaxTransLine = ...;
float CFTrans = ...;
float MinTransLine = ...;
float DOMSh = ...;
float MaxSol = ...;
float nonBeeTransLine = ...;
float cumTransLineLengthMax = ...;
float GenEff = ...;


//************Define parameters to be populated through Excel data*****************
//Supply
float SupInput[PlantXTime] = ...;
float ExSupInput[PlantXTime] = ...;
float CFInput[PlantRange] = ...;
float MinSizeInput[PlantRange] = ...;

//Demand
float DemBusInput[CellXTime] = ...;
float DemUInput[CellXTime] = ...;
float DemRInput[CellXTime] = ...;
float ERTarInput[TimeRange] = ...;
float ERTarBusInput[TimeRange] = ...;

//gen cost
float CGenIInput[PlantXTime] = ...;
float CGenOMInput[PlantXTime] = ...;

//Transmission cost
float CTrIFixInput[LineRange] = ...;
float CTrIVarInput[LineRange] = ...;
float CTrIDisInput[LineRange] = ...;

//Transmission distance
float LenInput[LineRange] = ...;

//Transmission losses
float TLossInput[TransLineRange] = ...;
float DLossInput[TransLineRange] = ...;

//Existing transmission
float ExTrInput[LineRange] = ...;

//Distribution cost
float CDisIUInput[CellXTime] = ...;
float CDisIRInput[CellXTime] = ...;
float CDisIUOffInput[CellXTime] = ...;
float CDisIROffInput[CellXTime] = ...;

//Transmission match
float TransLinePairMatchInput[LineXTransLine] = ...;

//Distribution losses
float DLossUInput[CellXTime] = ...;
float DLossRInput[CellXTime] = ...;
float DLossBusInput[CellXTime] = ...;

//Existing distribution
float ExUOnInput[CellXTime] = ...;
float ExUOffInput[CellXTime] = ...;
float ExROnInput[CellXTime] = ...;
float ExROffInput[CellXTime] = ...;
float ExBusInput[CellXTime] = ...;
float ExTrDInput[LineRange] = ...;

//EnergyBalanceFactor
float energyBalanceFactorTransInInput[CellXTransLine] = ...;
float energyBalanceFactorTransOutInput[CellXTransLine] = ...;

//District and GenTech plant match
float districtPlantMatchInput[CellXPlant] = ...;
float genTechPlantMatchInput[GenTechXPlant] = ...;

//Shortest path to grid parameter
//float shortestPathToGridInput[CellXTransLine] = ...;
float SPGridInput[ConnectedPlantncDistrXLine] = ...;

//Population data
float PopUInput[CellXTime] = ...;
float PopRInput[CellXTime] = ...;
float PopTotInput[TimeRange] = ...;

//CO2 Emissions
float CO2EmInput[GenTechRange] = ...;

//Discount factor
float DFInput[TimeRange] = ...;
float discountFactorAllTimeInput[AllTimeRange] = ...;


//gen binary fix
//int xGenFix[ConnectedPlant][Time] = ...;
//int xTransFix[NonExistLine][Time] = ...;


//**************Convert Excel data to multi-dimensional CPLEX data******************
//Supply
float Sup[Plant][Time];
int i = 1;
execute {
	for (var p in Plant) {
		for (var t in Time) {
			Sup[p][t] = SupInput[i];
			i = i + 1; 		
			}}
		i = 1;
		}
		
float ExSup[Plant][Time];
execute {
	for (var p in Plant) {
		for (var t in Time) {
			ExSup[p][t] = ExSupInput[i];
			i = i + 1; 		
			}}
		i = 1;
		}


float CF[Plant];
int cf = 1;
execute {
	for (var p in Plant) {
		CF[p] = CFInput[cf];
		cf = cf + 1;
  		}}


float MinSize[Plant];
int mps = 1;
execute {
	for (var p in Plant) {
		MinSize[p] = MinSizeInput[mps];
		mps = mps + 1;
  		}}


//Demand
float DemBus[Cell][Time];
int j = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			DemBus[c][t] = DemBusInput[j];
			j = j + 1;
  		}}}
  		
float DemU[Cell][Time];
int jtwo = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			DemU[c][t] = DemUInput[jtwo];
			jtwo = jtwo + 1;
  		}}}
  		
float DemR[Cell][Time];
int jthree = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			DemR[c][t] = DemRInput[jthree];
			jthree = jthree + 1;
  		}}}

float ERTar[Time];
int jfour = 1;
execute {
	for (var t in Time) {	
		ERTar[t] = ERTarInput[jfour];
		jfour = jfour + 1;
  		}}


float ERTarBus[Time];
int jfourd = 1;
execute {
	for (var t in Time) {	
		ERTarBus[t] = ERTarBusInput[jfourd];
		jfourd = jfourd + 1;
  		}}
	

//gen cost
float CGenI[Plant][Time];
int k = 1;
execute {
	for (var p in Plant) {
		for (var t in Time) {		
			CGenI[p][t] = CGenIInput[k];
			k = k + 1; 				
		}}}	

float CGenOM[Plant][Time];
int ld2 = 1;
execute {
	for (var p in Plant) {
		for (var t in Time) {		
			CGenOM[p][t] = CGenOMInput[ld2];
			ld2 = ld2 + 1; 				
		}}}


//Transmission cost
float CTrIFix[Line];
int m = 1;
execute {
	for (var l in Line) {
		CTrIFix[l] = CTrIFixInput[m];
		m = m + 1; 				
		}}

float CTrIVar[Line];
int mthree = 1;
execute {
	for (var l in Line) {
		CTrIVar[l] = CTrIVarInput[mthree];
		mthree = mthree + 1; 				
		}}

float CTrIDis[Line];
int invd = 1;
execute {
	for (var l in Line) {
		CTrIDis[l] = CTrIDisInput[invd];
		invd = invd + 1; 				
		}}


//Transmission distance
float Len[Line];
int dist = 1;
execute {
	for (var l in Line) {
		Len[l] = LenInput[dist];
		dist = dist + 1; 				
		}}

//Transmission losses
float TLoss[TransLine];
int q = 1;
execute {
	for (var ldir in TransLine) {
		TLoss[ldir] = TLossInput[q];
		q = q + 1; 				
		}}

float DLoss[TransLine];
int qtwo = 1;
execute {
	for (var d in TransLine) {
		DLoss[d] = DLossInput[qtwo];
		qtwo = qtwo + 1; 				
		}}


//Existing Transmission
float ExTr[Line];
int mfour = 1;
execute {
	for (var l in Line) {
		ExTr[l] = ExTrInput[mfour];
		mfour = mfour + 1; 				
		}}

//Transmission match
float TransLinePairMatch[Line][TransLine];
int mtl = 1;
execute {
	for (var l in Line) {
		for (var ldir in TransLine) {	
			TransLinePairMatch[l][ldir] = TransLinePairMatchInput[mtl];
			mtl = mtl + 1; 				
		}}}


//Distribution costs
float CDisIU[Cell][Time];
int n = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			CDisIU[c][t] = CDisIUInput[n];
			n = n + 1;
  		}}}
	
float CDisIR[Cell][Time];
int ntwo = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			CDisIR[c][t] = CDisIRInput[ntwo];
			ntwo = ntwo + 1;
  		}}}

float CDisIROff[Cell][Time];
int nten = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			CDisIROff[c][t] = CDisIROffInput[nten];
			nten = nten + 1;
  		}}} 
 
float CDisIUOff[Cell][Time];
int nten2 = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			CDisIUOff[c][t] = CDisIUOffInput[nten2];
			nten2 = nten2 + 1;
  		}}} 
 


//Distribution losses
float DLossU[Cell][Time];
int nthree = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			DLossU[c][t] = DLossUInput[nthree];
			nthree = nthree + 1;
  		}}}

float DLossR[Cell][Time];
int nfour = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			DLossR[c][t] = DLossRInput[nfour];
			nfour = nfour + 1;
  		}}}


float DLossBus[Cell][Time];
int nfive = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			DLossBus[c][t] = DLossBusInput[nfive];
			nfive = nfive + 1;
  		}}}


//Existing distribution 
float ExUOn[Cell][Time];
int nsix = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			ExUOn[c][t] = ExUOnInput[nsix];
			nsix = nsix + 1;
  		}}}

float ExUOff[Cell][Time];
int nseven = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			ExUOff[c][t] = ExUOffInput[nseven];
			nseven = nseven + 1;
  		}}}
 
 float ExROn[Cell][Time];
int neight = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			ExROn[c][t] = ExROnInput[neight];
			neight = neight + 1;
  		}}}
 
float ExROff[Cell][Time];
int nnine = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			ExROff[c][t] = ExROffInput[nnine];
			nnine = nnine + 1;
  		}}}
 
float ExBus[Cell][Time];
int nninetwo = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			ExBus[c][t] = ExBusInput[nninetwo];
			nninetwo = nninetwo + 1;
  		}}} 
 
 
float ExTrD[Line];
int ntentwo = 1;
execute {
	for (var l in Line) {	
			ExTrD[l] = ExTrDInput[ntentwo];
			ntentwo = ntentwo + 1;
  		}}
 
 
//Energy balances factor
float energyBalanceFactorTransIn[Cell][TransLine];
int p = 1;
execute {
	for (var c in Cell) {
		for (var ldir in TransLine) {	
			energyBalanceFactorTransIn[c][ldir] = energyBalanceFactorTransInInput[p];
			p = p + 1;
  		}}}

float energyBalanceFactorTransOut[Cell][TransLine];
int ptwo = 1;
execute {
	for (var c in Cell) {
		for (var ldir in TransLine) {	
			energyBalanceFactorTransOut[c][ldir] = energyBalanceFactorTransOutInput[ptwo];
			ptwo = ptwo + 1;
  		}}}


//District and GenTech plant match
float districtPlantMatch[Cell][Plant];
execute {
	for (var c in Cell) {
		for (var p in Plant) {	
			districtPlantMatch[c][p] = districtPlantMatchInput[i];
			i = i + 1;
  		}}
  		i = 1;
  		}

float genTechPlantMatch[GenTech][Plant];
execute {
	for (var g in GenTech) {
		for (var p in Plant) {	
			genTechPlantMatch[g][p] = genTechPlantMatchInput[i];
			i = i + 1;
  		}}
  		i = 1;
  		}


//Shortest path to grid parameter
float SPGrid[ConnectedPlantNotconnectedDistrict][Line];
int sp2 = 1;
execute {
	for (var p in ConnectedPlantNotconnectedDistrict) {
		for (var l in Line) {	
			SPGrid[p][l] = SPGridInput[sp2];
			sp2 = sp2 + 1;
  		}}}


//Population data
float PopU[Cell][Time];
int o = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			PopU[c][t] = PopUInput[o];
			o = o + 1;
  		}}}

float PopR[Cell][Time];
int otwo = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {	
			PopR[c][t] = PopRInput[otwo];
			otwo = otwo + 1;
  		}}}  		

float PopTot[Time];
int othree = 1;
execute {
	for (var t in Time) {	
		PopTot[t] = PopTotInput[othree];
		othree = othree + 1;
  		}}


//CO2Em
float CO2Em[GenTech];
int z = 1;
execute {
	for (var g in GenTech) {
			CO2Em[g] = CO2EmInput[z];
			z = z + 1; 		
		}}

//Discount factor
float DF[Time];
int df1 = 1;
execute {
	for (var t in Time) {
			DF[t] = DFInput[df1];
			df1 = df1 + 1; 		
		}}

float discountFactorAllTime[AllTime];
int df2 = 1;
execute {
	for (var t in AllTime) {
			discountFactorAllTime[t] = discountFactorAllTimeInput[df2];
			df2 = df2 + 1; 		
		}}

//**************************Define decision variables***********************************
dvar float+ genCap[Plant][Time];
dvar float+ gen[Plant][Time];
dvar float+ genCC[Plant][Time];

dvar float+ transCap[Line][Time];
dvar float+ trans[TransLine][Time];
dvar float+ transCC[Line][Time];
dvar float+ transD[TransLine][Time];
dvar float+ disR[Cell][Time];
dvar float+ disU[Cell][Time];
dvar float+ disBus[Cell][Time];

dvar float+ elUp[Cell][Time];
dvar float+ elDown[Cell][Time];

dvar float+ elBus[Cell][Time];
dvar float+ elUOn[Cell][Time];
dvar float+ elROn[Cell][Time];

dvar float+ elUOff[Cell][Time];
dvar float+ elROff[Cell][Time];

dvar float+ erU[Cell][Time];
dvar float+ erR[Cell][Time];
dvar float+ erTot[Cell][Time];
dvar float+ erBus[Cell][Time];

dvar boolean xGen[ConnectedPlant][Time];
dvar boolean xTrans[NonExistLine][Time];



//Calculate costs, bearing in mind the LCOE assumption which changes every 5 Times but then needs to be paid throughout the planning horizon
dexpr float CTotGenI = 
	sum (p in Plant, t in Time) (genCap[p][t] * CGenI[p][t] / DF[t]);

dexpr float CTotGenOM = 
	sum (p in Plant) (
	(((0.0 * gen[p]["2025"] + 1.0 * gen[p]["2020"]) * (0.0 * CGenOM[p]["2025"] + 1.0 * CGenOM[p]["2020"])) / discountFactorAllTime["2020"]) +
	(((0.2 * gen[p]["2025"] + 0.8 * gen[p]["2020"]) * (0.2 * CGenOM[p]["2025"] + 0.8 * CGenOM[p]["2020"])) / discountFactorAllTime["2021"]) +
	(((0.4 * gen[p]["2025"] + 0.6 * gen[p]["2020"]) * (0.4 * CGenOM[p]["2025"] + 0.6 * CGenOM[p]["2020"])) / discountFactorAllTime["2022"]) +
	(((0.6 * gen[p]["2025"] + 0.4 * gen[p]["2020"]) * (0.6 * CGenOM[p]["2025"] + 0.4 * CGenOM[p]["2020"])) / discountFactorAllTime["2023"]) +
	(((0.8 * gen[p]["2025"] + 0.2 * gen[p]["2020"]) * (0.8 * CGenOM[p]["2025"] + 0.2 * CGenOM[p]["2020"])) / discountFactorAllTime["2024"]) +
	(((1.0 * gen[p]["2025"] + 0.0 * gen[p]["2020"]) * (1.0 * CGenOM[p]["2025"] + 0.0 * CGenOM[p]["2020"])) / discountFactorAllTime["2025"]) +
	(((0.2 * gen[p]["2030"] + 0.8 * gen[p]["2025"]) * (0.2 * CGenOM[p]["2030"] + 0.8 * CGenOM[p]["2025"])) / discountFactorAllTime["2026"]) +
	(((0.4 * gen[p]["2030"] + 0.6 * gen[p]["2025"]) * (0.4 * CGenOM[p]["2030"] + 0.6 * CGenOM[p]["2025"])) / discountFactorAllTime["2027"]) +
	(((0.6 * gen[p]["2030"] + 0.4 * gen[p]["2025"]) * (0.6 * CGenOM[p]["2030"] + 0.4 * CGenOM[p]["2025"])) / discountFactorAllTime["2028"]) +
	(((0.8 * gen[p]["2030"] + 0.2 * gen[p]["2025"]) * (0.8 * CGenOM[p]["2030"] + 0.2 * CGenOM[p]["2025"])) / discountFactorAllTime["2029"]) +
	(((1.0 * gen[p]["2030"] + 0.0 * gen[p]["2025"]) * (1.0 * CGenOM[p]["2030"] + 0.0 * CGenOM[p]["2025"])) / discountFactorAllTime["2030"]) +
	(((0.2 * gen[p]["2035"] + 0.8 * gen[p]["2030"]) * (0.2 * CGenOM[p]["2035"] + 0.8 * CGenOM[p]["2030"])) / discountFactorAllTime["2031"]) +
	(((0.4 * gen[p]["2035"] + 0.6 * gen[p]["2030"]) * (0.4 * CGenOM[p]["2035"] + 0.6 * CGenOM[p]["2030"])) / discountFactorAllTime["2032"]) +
	(((0.6 * gen[p]["2035"] + 0.4 * gen[p]["2030"]) * (0.6 * CGenOM[p]["2035"] + 0.4 * CGenOM[p]["2030"])) / discountFactorAllTime["2033"]) +
	(((0.8 * gen[p]["2035"] + 0.2 * gen[p]["2030"]) * (0.8 * CGenOM[p]["2035"] + 0.2 * CGenOM[p]["2030"])) / discountFactorAllTime["2034"]) +
	(((1.0 * gen[p]["2035"] + 0.0 * gen[p]["2030"]) * (1.0 * CGenOM[p]["2035"] + 0.0 * CGenOM[p]["2030"])) / discountFactorAllTime["2035"]) +
	(((0.2 * gen[p]["2040"] + 0.8 * gen[p]["2035"]) * (0.2 * CGenOM[p]["2040"] + 0.8 * CGenOM[p]["2035"])) / discountFactorAllTime["2036"]) +
	(((0.4 * gen[p]["2040"] + 0.6 * gen[p]["2035"]) * (0.4 * CGenOM[p]["2040"] + 0.6 * CGenOM[p]["2035"])) / discountFactorAllTime["2037"]) +
	(((0.6 * gen[p]["2040"] + 0.4 * gen[p]["2035"]) * (0.6 * CGenOM[p]["2040"] + 0.4 * CGenOM[p]["2035"])) / discountFactorAllTime["2038"]) +
	(((0.8 * gen[p]["2040"] + 0.2 * gen[p]["2035"]) * (0.8 * CGenOM[p]["2040"] + 0.2 * CGenOM[p]["2035"])) / discountFactorAllTime["2039"]) +
	(((1.0 * gen[p]["2040"] + 0.0 * gen[p]["2035"]) * (1.0 * CGenOM[p]["2040"] + 0.0 * CGenOM[p]["2035"])) / discountFactorAllTime["2040"])
	);
	
dexpr float CTotTrI =  
	sum (t in Time) (((sum(nel in NonExistLine) (xTrans[nel][t] * CTrIFix[nel])) + (sum(l in Line) (transCap[l][t] * CTrIVar[l]))) / DF[t]);
	
dexpr float CTotTrOM = 
	sum (l in Line) (
	((((0.0 * transCC[l]["2025"] + 1.0 * transCC[l]["2020"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2020"]) + 
	((((0.2 * transCC[l]["2025"] + 0.8 * transCC[l]["2020"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2021"]) + 
	((((0.4 * transCC[l]["2025"] + 0.6 * transCC[l]["2020"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2022"]) + 
	((((0.6 * transCC[l]["2025"] + 0.4 * transCC[l]["2020"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2023"]) + 
	((((0.8 * transCC[l]["2025"] + 0.2 * transCC[l]["2020"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2024"]) + 
	((((1.0 * transCC[l]["2025"] + 0.0 * transCC[l]["2020"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2025"]) + 
	((((0.2 * transCC[l]["2030"] + 0.8 * transCC[l]["2025"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2026"]) + 
	((((0.4 * transCC[l]["2030"] + 0.6 * transCC[l]["2025"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2027"]) + 
	((((0.6 * transCC[l]["2030"] + 0.4 * transCC[l]["2025"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2028"]) + 
	((((0.8 * transCC[l]["2030"] + 0.2 * transCC[l]["2025"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2029"]) + 
	((((1.0 * transCC[l]["2030"] + 0.0 * transCC[l]["2025"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2030"]) + 
	((((0.2 * transCC[l]["2035"] + 0.8 * transCC[l]["2030"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2031"]) + 
	((((0.4 * transCC[l]["2035"] + 0.6 * transCC[l]["2030"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2032"]) + 
	((((0.6 * transCC[l]["2035"] + 0.4 * transCC[l]["2030"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2033"]) + 
	((((0.8 * transCC[l]["2035"] + 0.2 * transCC[l]["2030"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2034"]) + 
	((((1.0 * transCC[l]["2035"] + 0.0 * transCC[l]["2030"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2035"]) + 
	((((0.2 * transCC[l]["2040"] + 0.8 * transCC[l]["2035"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2036"]) + 
	((((0.4 * transCC[l]["2040"] + 0.6 * transCC[l]["2035"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2037"]) + 
	((((0.6 * transCC[l]["2040"] + 0.4 * transCC[l]["2035"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2038"]) + 
	((((0.8 * transCC[l]["2040"] + 0.2 * transCC[l]["2035"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2039"]) + 
	((((1.0 * transCC[l]["2040"] + 0.0 * transCC[l]["2035"] + ExTr[l]) * CTrIVar[l]) * TOMSh) / discountFactorAllTime["2040"]) +  
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2020"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2021"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2022"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2023"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2024"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2025"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2026"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2027"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2028"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2029"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2030"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2031"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2032"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2033"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2034"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2035"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2036"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2037"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2038"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2039"]) + 
	((ExTrD[l] * CTrIDis[l] * DOMSh) / discountFactorAllTime["2040"]) 
	);
	
//Neglect business connection investment and OM costs	
dexpr float CTotDisI = 
	sum (c in Cell) (
	((((elUOn[c]["2020"] * (1 - DLossU[c]["2020"]) - ExUOn[c]["2020"]) / DemU[c]["2020"]) * PopU[c]["2020"] * CDisIU[c]["2020"]) + (((elROn[c]["2020"] * (1 - DLossR[c]["2020"]) - ExROn[c]["2020"]) / DemR[c]["2020"]) * PopR[c]["2020"] * CDisIR[c]["2020"]) / DF["2020"]) + 
	(((((elUOn[c]["2025"] * (1 - DLossU[c]["2025"])) / DemU[c]["2025"]) * PopU[c]["2025"] - ((elUOn[c]["2020"] * (1 - DLossU[c]["2020"]) / DemU[c]["2020"]) * PopU[c]["2020"])) * CDisIU[c]["2025"]) + ((((elROn[c]["2025"] * (1 - DLossR[c]["2025"])) / DemR[c]["2025"]) * PopR[c]["2025"] - ((elROn[c]["2020"] * (1 - DLossR[c]["2020"]) / DemR[c]["2020"]) * PopR[c]["2020"])) * CDisIR[c]["2025"])) +
	(((((elUOn[c]["2030"] * (1 - DLossU[c]["2030"])) / DemU[c]["2030"]) * PopU[c]["2030"] - ((elUOn[c]["2025"] * (1 - DLossU[c]["2025"]) / DemU[c]["2025"]) * PopU[c]["2025"])) * CDisIU[c]["2030"]) + ((((elROn[c]["2030"] * (1 - DLossR[c]["2030"])) / DemR[c]["2030"]) * PopR[c]["2030"] - ((elROn[c]["2025"] * (1 - DLossR[c]["2025"]) / DemR[c]["2025"]) * PopR[c]["2025"])) * CDisIR[c]["2030"])) +
	(((((elUOn[c]["2035"] * (1 - DLossU[c]["2035"])) / DemU[c]["2035"]) * PopU[c]["2035"] - ((elUOn[c]["2030"] * (1 - DLossU[c]["2030"]) / DemU[c]["2030"]) * PopU[c]["2030"])) * CDisIU[c]["2035"]) + ((((elROn[c]["2035"] * (1 - DLossR[c]["2035"])) / DemR[c]["2035"]) * PopR[c]["2035"] - ((elROn[c]["2030"] * (1 - DLossR[c]["2030"]) / DemR[c]["2030"]) * PopR[c]["2030"])) * CDisIR[c]["2035"])) +
	(((((elUOn[c]["2040"] * (1 - DLossU[c]["2040"])) / DemU[c]["2040"]) * PopU[c]["2040"] - ((elUOn[c]["2035"] * (1 - DLossU[c]["2035"]) / DemU[c]["2035"]) * PopU[c]["2035"])) * CDisIU[c]["2040"]) + ((((elROn[c]["2040"] * (1 - DLossR[c]["2040"])) / DemR[c]["2040"]) * PopR[c]["2040"] - ((elROn[c]["2035"] * (1 - DLossR[c]["2035"]) / DemR[c]["2035"]) * PopR[c]["2035"])) * CDisIR[c]["2040"])) +
	((elROff[c]["2020"] * CDisIROff[c]["2020"] * OGAddInv) / DF["2020"]) + 
	(((elROff[c]["2025"] - elROff[c]["2020"]) * CDisIROff[c]["2025"] * OGAddInv) / DF["2025"]) + 
	(((elROff[c]["2030"] - elROff[c]["2025"]) * CDisIROff[c]["2030"] * OGAddInv) / DF["2030"]) + 
	(((elROff[c]["2035"] - elROff[c]["2030"]) * CDisIROff[c]["2035"] * OGAddInv) / DF["2035"]) + 
	(((elROff[c]["2040"] - elROff[c]["2035"]) * CDisIROff[c]["2040"] * OGAddInv) / DF["2040"]) +
	((elUOff[c]["2020"] * CDisIUOff[c]["2020"] * OGAddInv) / DF["2020"]) + 
	(((elUOff[c]["2025"] - elUOff[c]["2020"]) * CDisIUOff[c]["2025"] * OGAddInv) / DF["2025"]) + 
	(((elUOff[c]["2030"] - elUOff[c]["2025"]) * CDisIUOff[c]["2030"] * OGAddInv) / DF["2030"]) + 
	(((elUOff[c]["2035"] - elUOff[c]["2030"]) * CDisIUOff[c]["2035"] * OGAddInv) / DF["2035"]) + 
	(((elUOff[c]["2040"] - elUOff[c]["2035"]) * CDisIUOff[c]["2040"] * OGAddInv) / DF["2040"])
	);	

dexpr float CTotDisOM = 
	sum (c in Cell) (
	(((1.0 * ((elUOn[c]["2020"] * (1 - DLossU[c]["2020"])) / DemU[c]["2020"]) * PopU[c]["2020"] + 0.0 * ((elUOn[c]["2025"] * (1 - DLossU[c]["2025"]) * PopU[c]["2025"]) / DemU[c]["2025"])) * (1.0 * CDisIU[c]["2020"] + 0.0 * CDisIU[c]["2025"]) * DOMSh) / discountFactorAllTime["2020"]) +  
	(((0.8 * ((elUOn[c]["2020"] * (1 - DLossU[c]["2020"])) / DemU[c]["2020"]) * PopU[c]["2020"] + 0.2 * ((elUOn[c]["2025"] * (1 - DLossU[c]["2025"]) * PopU[c]["2025"]) / DemU[c]["2025"])) * (0.8 * CDisIU[c]["2020"] + 0.2 * CDisIU[c]["2025"]) * DOMSh) / discountFactorAllTime["2021"]) +  
	(((0.6 * ((elUOn[c]["2020"] * (1 - DLossU[c]["2020"])) / DemU[c]["2020"]) * PopU[c]["2020"] + 0.4 * ((elUOn[c]["2025"] * (1 - DLossU[c]["2025"]) * PopU[c]["2025"]) / DemU[c]["2025"])) * (0.6 * CDisIU[c]["2020"] + 0.4 * CDisIU[c]["2025"]) * DOMSh) / discountFactorAllTime["2022"]) +  
	(((0.4 * ((elUOn[c]["2020"] * (1 - DLossU[c]["2020"])) / DemU[c]["2020"]) * PopU[c]["2020"] + 0.6 * ((elUOn[c]["2025"] * (1 - DLossU[c]["2025"]) * PopU[c]["2025"]) / DemU[c]["2025"])) * (0.4 * CDisIU[c]["2020"] + 0.6 * CDisIU[c]["2025"]) * DOMSh) / discountFactorAllTime["2023"]) +  
	(((0.2 * ((elUOn[c]["2020"] * (1 - DLossU[c]["2020"])) / DemU[c]["2020"]) * PopU[c]["2020"] + 0.8 * ((elUOn[c]["2025"] * (1 - DLossU[c]["2025"]) * PopU[c]["2025"]) / DemU[c]["2025"])) * (0.2 * CDisIU[c]["2020"] + 0.8 * CDisIU[c]["2025"]) * DOMSh) / discountFactorAllTime["2024"]) +  
	(((0.0 * ((elUOn[c]["2020"] * (1 - DLossU[c]["2020"])) / DemU[c]["2020"]) * PopU[c]["2020"] + 1.0 * ((elUOn[c]["2025"] * (1 - DLossU[c]["2025"]) * PopU[c]["2025"]) / DemU[c]["2025"])) * (0.0 * CDisIU[c]["2020"] + 1.0 * CDisIU[c]["2025"]) * DOMSh) / discountFactorAllTime["2025"]) +  
	(((0.8 * ((elUOn[c]["2025"] * (1 - DLossU[c]["2025"])) / DemU[c]["2025"]) * PopU[c]["2020"] + 0.2 * ((elUOn[c]["2030"] * (1 - DLossU[c]["2030"]) * PopU[c]["2030"]) / DemU[c]["2030"])) * (0.8 * CDisIU[c]["2025"] + 0.2 * CDisIU[c]["2030"]) * DOMSh) / discountFactorAllTime["2026"]) +  
	(((0.6 * ((elUOn[c]["2025"] * (1 - DLossU[c]["2025"])) / DemU[c]["2025"]) * PopU[c]["2025"] + 0.4 * ((elUOn[c]["2030"] * (1 - DLossU[c]["2030"]) * PopU[c]["2030"]) / DemU[c]["2030"])) * (0.6 * CDisIU[c]["2025"] + 0.4 * CDisIU[c]["2030"]) * DOMSh) / discountFactorAllTime["2027"]) +  
	(((0.4 * ((elUOn[c]["2025"] * (1 - DLossU[c]["2025"])) / DemU[c]["2025"]) * PopU[c]["2025"] + 0.6 * ((elUOn[c]["2030"] * (1 - DLossU[c]["2030"]) * PopU[c]["2030"]) / DemU[c]["2030"])) * (0.4 * CDisIU[c]["2025"] + 0.6 * CDisIU[c]["2030"]) * DOMSh) / discountFactorAllTime["2028"]) +  
	(((0.2 * ((elUOn[c]["2025"] * (1 - DLossU[c]["2025"])) / DemU[c]["2025"]) * PopU[c]["2025"] + 0.8 * ((elUOn[c]["2030"] * (1 - DLossU[c]["2030"]) * PopU[c]["2030"]) / DemU[c]["2030"])) * (0.2 * CDisIU[c]["2025"] + 0.8 * CDisIU[c]["2030"]) * DOMSh) / discountFactorAllTime["2029"]) +  
	(((0.0 * ((elUOn[c]["2025"] * (1 - DLossU[c]["2025"])) / DemU[c]["2025"]) * PopU[c]["2025"] + 1.0 * ((elUOn[c]["2030"] * (1 - DLossU[c]["2030"]) * PopU[c]["2030"]) / DemU[c]["2030"])) * (0.0 * CDisIU[c]["2025"] + 1.0 * CDisIU[c]["2030"]) * DOMSh) / discountFactorAllTime["2030"]) +  
	(((0.8 * ((elUOn[c]["2030"] * (1 - DLossU[c]["2030"])) / DemU[c]["2030"]) * PopU[c]["2030"] + 0.2 * ((elUOn[c]["2035"] * (1 - DLossU[c]["2035"]) * PopU[c]["2035"]) / DemU[c]["2035"])) * (0.8 * CDisIU[c]["2030"] + 0.2 * CDisIU[c]["2035"]) * DOMSh) / discountFactorAllTime["2031"]) +  
	(((0.6 * ((elUOn[c]["2030"] * (1 - DLossU[c]["2030"])) / DemU[c]["2030"]) * PopU[c]["2030"] + 0.4 * ((elUOn[c]["2035"] * (1 - DLossU[c]["2035"]) * PopU[c]["2035"]) / DemU[c]["2035"])) * (0.6 * CDisIU[c]["2030"] + 0.4 * CDisIU[c]["2035"]) * DOMSh) / discountFactorAllTime["2032"]) +  
	(((0.4 * ((elUOn[c]["2030"] * (1 - DLossU[c]["2030"])) / DemU[c]["2030"]) * PopU[c]["2030"] + 0.6 * ((elUOn[c]["2035"] * (1 - DLossU[c]["2035"]) * PopU[c]["2035"]) / DemU[c]["2035"])) * (0.4 * CDisIU[c]["2030"] + 0.6 * CDisIU[c]["2035"]) * DOMSh) / discountFactorAllTime["2033"]) +  
	(((0.2 * ((elUOn[c]["2030"] * (1 - DLossU[c]["2030"])) / DemU[c]["2030"]) * PopU[c]["2030"] + 0.8 * ((elUOn[c]["2035"] * (1 - DLossU[c]["2035"]) * PopU[c]["2035"]) / DemU[c]["2035"])) * (0.2 * CDisIU[c]["2030"] + 0.8 * CDisIU[c]["2035"]) * DOMSh) / discountFactorAllTime["2034"]) +  
	(((0.0 * ((elUOn[c]["2030"] * (1 - DLossU[c]["2030"])) / DemU[c]["2030"]) * PopU[c]["2030"] + 1.0 * ((elUOn[c]["2035"] * (1 - DLossU[c]["2035"]) * PopU[c]["2035"]) / DemU[c]["2035"])) * (0.0 * CDisIU[c]["2030"] + 1.0 * CDisIU[c]["2035"]) * DOMSh) / discountFactorAllTime["2035"]) +  
	(((0.8 * ((elUOn[c]["2035"] * (1 - DLossU[c]["2035"])) / DemU[c]["2035"]) * PopU[c]["2035"] + 0.2 * ((elUOn[c]["2040"] * (1 - DLossU[c]["2040"]) * PopU[c]["2040"]) / DemU[c]["2040"])) * (0.8 * CDisIU[c]["2035"] + 0.2 * CDisIU[c]["2040"]) * DOMSh) / discountFactorAllTime["2036"]) +  
	(((0.6 * ((elUOn[c]["2035"] * (1 - DLossU[c]["2035"])) / DemU[c]["2035"]) * PopU[c]["2035"] + 0.4 * ((elUOn[c]["2040"] * (1 - DLossU[c]["2040"]) * PopU[c]["2040"]) / DemU[c]["2040"])) * (0.6 * CDisIU[c]["2035"] + 0.4 * CDisIU[c]["2040"]) * DOMSh) / discountFactorAllTime["2037"]) +  
	(((0.4 * ((elUOn[c]["2035"] * (1 - DLossU[c]["2035"])) / DemU[c]["2035"]) * PopU[c]["2035"] + 0.6 * ((elUOn[c]["2040"] * (1 - DLossU[c]["2040"]) * PopU[c]["2040"]) / DemU[c]["2040"])) * (0.4 * CDisIU[c]["2035"] + 0.6 * CDisIU[c]["2040"]) * DOMSh) / discountFactorAllTime["2038"]) +  
	(((0.2 * ((elUOn[c]["2035"] * (1 - DLossU[c]["2035"])) / DemU[c]["2035"]) * PopU[c]["2035"] + 0.8 * ((elUOn[c]["2040"] * (1 - DLossU[c]["2040"]) * PopU[c]["2040"]) / DemU[c]["2040"])) * (0.2 * CDisIU[c]["2035"] + 0.8 * CDisIU[c]["2040"]) * DOMSh) / discountFactorAllTime["2039"]) +  
	(((0.0 * ((elUOn[c]["2035"] * (1 - DLossU[c]["2035"])) / DemU[c]["2035"]) * PopU[c]["2035"] + 1.0 * ((elUOn[c]["2040"] * (1 - DLossU[c]["2040"]) * PopU[c]["2040"]) / DemU[c]["2040"])) * (0.0 * CDisIU[c]["2035"] + 1.0 * CDisIU[c]["2040"]) * DOMSh) / discountFactorAllTime["2040"]) +  
	(((1.0 * ((elROn[c]["2020"] * (1 - DLossR[c]["2020"])) / DemR[c]["2020"]) * PopR[c]["2020"] + 0.0 * ((elROn[c]["2025"] * (1 - DLossR[c]["2025"]) * PopR[c]["2025"]) / DemR[c]["2025"])) * (1.0 * CDisIR[c]["2020"] + 0.0 * CDisIR[c]["2025"]) * DOMSh) / discountFactorAllTime["2020"]) +  
	(((0.8 * ((elROn[c]["2020"] * (1 - DLossR[c]["2020"])) / DemR[c]["2020"]) * PopR[c]["2020"] + 0.2 * ((elROn[c]["2025"] * (1 - DLossR[c]["2025"]) * PopR[c]["2025"]) / DemR[c]["2025"])) * (0.8 * CDisIR[c]["2020"] + 0.2 * CDisIR[c]["2025"]) * DOMSh) / discountFactorAllTime["2021"]) +  
	(((0.6 * ((elROn[c]["2020"] * (1 - DLossR[c]["2020"])) / DemR[c]["2020"]) * PopR[c]["2020"] + 0.4 * ((elROn[c]["2025"] * (1 - DLossR[c]["2025"]) * PopR[c]["2025"]) / DemR[c]["2025"])) * (0.6 * CDisIR[c]["2020"] + 0.4 * CDisIR[c]["2025"]) * DOMSh) / discountFactorAllTime["2022"]) +  
	(((0.4 * ((elROn[c]["2020"] * (1 - DLossR[c]["2020"])) / DemR[c]["2020"]) * PopR[c]["2020"] + 0.6 * ((elROn[c]["2025"] * (1 - DLossR[c]["2025"]) * PopR[c]["2025"]) / DemR[c]["2025"])) * (0.4 * CDisIR[c]["2020"] + 0.6 * CDisIR[c]["2025"]) * DOMSh) / discountFactorAllTime["2023"]) +  
	(((0.2 * ((elROn[c]["2020"] * (1 - DLossR[c]["2020"])) / DemR[c]["2020"]) * PopR[c]["2020"] + 0.8 * ((elROn[c]["2025"] * (1 - DLossR[c]["2025"]) * PopR[c]["2025"]) / DemR[c]["2025"])) * (0.2 * CDisIR[c]["2020"] + 0.8 * CDisIR[c]["2025"]) * DOMSh) / discountFactorAllTime["2024"]) +  
	(((0.0 * ((elROn[c]["2020"] * (1 - DLossR[c]["2020"])) / DemR[c]["2020"]) * PopR[c]["2020"] + 1.0 * ((elROn[c]["2025"] * (1 - DLossR[c]["2025"]) * PopR[c]["2025"]) / DemR[c]["2025"])) * (0.0 * CDisIR[c]["2020"] + 1.0 * CDisIR[c]["2025"]) * DOMSh) / discountFactorAllTime["2025"]) +  
	(((0.8 * ((elROn[c]["2025"] * (1 - DLossR[c]["2025"])) / DemR[c]["2025"]) * PopR[c]["2020"] + 0.2 * ((elROn[c]["2030"] * (1 - DLossR[c]["2030"]) * PopR[c]["2030"]) / DemR[c]["2030"])) * (0.8 * CDisIR[c]["2025"] + 0.2 * CDisIR[c]["2030"]) * DOMSh) / discountFactorAllTime["2026"]) +  
	(((0.6 * ((elROn[c]["2025"] * (1 - DLossR[c]["2025"])) / DemR[c]["2025"]) * PopR[c]["2025"] + 0.4 * ((elROn[c]["2030"] * (1 - DLossR[c]["2030"]) * PopR[c]["2030"]) / DemR[c]["2030"])) * (0.6 * CDisIR[c]["2025"] + 0.4 * CDisIR[c]["2030"]) * DOMSh) / discountFactorAllTime["2027"]) +  
	(((0.4 * ((elROn[c]["2025"] * (1 - DLossR[c]["2025"])) / DemR[c]["2025"]) * PopR[c]["2025"] + 0.6 * ((elROn[c]["2030"] * (1 - DLossR[c]["2030"]) * PopR[c]["2030"]) / DemR[c]["2030"])) * (0.4 * CDisIR[c]["2025"] + 0.6 * CDisIR[c]["2030"]) * DOMSh) / discountFactorAllTime["2028"]) +  
	(((0.2 * ((elROn[c]["2025"] * (1 - DLossR[c]["2025"])) / DemR[c]["2025"]) * PopR[c]["2025"] + 0.8 * ((elROn[c]["2030"] * (1 - DLossR[c]["2030"]) * PopR[c]["2030"]) / DemR[c]["2030"])) * (0.2 * CDisIR[c]["2025"] + 0.8 * CDisIR[c]["2030"]) * DOMSh) / discountFactorAllTime["2029"]) +  
	(((0.0 * ((elROn[c]["2025"] * (1 - DLossR[c]["2025"])) / DemR[c]["2025"]) * PopR[c]["2025"] + 1.0 * ((elROn[c]["2030"] * (1 - DLossR[c]["2030"]) * PopR[c]["2030"]) / DemR[c]["2030"])) * (0.0 * CDisIR[c]["2025"] + 1.0 * CDisIR[c]["2030"]) * DOMSh) / discountFactorAllTime["2030"]) +  
	(((0.8 * ((elROn[c]["2030"] * (1 - DLossR[c]["2030"])) / DemR[c]["2030"]) * PopR[c]["2030"] + 0.2 * ((elROn[c]["2035"] * (1 - DLossR[c]["2035"]) * PopR[c]["2035"]) / DemR[c]["2035"])) * (0.8 * CDisIR[c]["2030"] + 0.2 * CDisIR[c]["2035"]) * DOMSh) / discountFactorAllTime["2031"]) +  
	(((0.6 * ((elROn[c]["2030"] * (1 - DLossR[c]["2030"])) / DemR[c]["2030"]) * PopR[c]["2030"] + 0.4 * ((elROn[c]["2035"] * (1 - DLossR[c]["2035"]) * PopR[c]["2035"]) / DemR[c]["2035"])) * (0.6 * CDisIR[c]["2030"] + 0.4 * CDisIR[c]["2035"]) * DOMSh) / discountFactorAllTime["2032"]) +  
	(((0.4 * ((elROn[c]["2030"] * (1 - DLossR[c]["2030"])) / DemR[c]["2030"]) * PopR[c]["2030"] + 0.6 * ((elROn[c]["2035"] * (1 - DLossR[c]["2035"]) * PopR[c]["2035"]) / DemR[c]["2035"])) * (0.4 * CDisIR[c]["2030"] + 0.6 * CDisIR[c]["2035"]) * DOMSh) / discountFactorAllTime["2033"]) +  
	(((0.2 * ((elROn[c]["2030"] * (1 - DLossR[c]["2030"])) / DemR[c]["2030"]) * PopR[c]["2030"] + 0.8 * ((elROn[c]["2035"] * (1 - DLossR[c]["2035"]) * PopR[c]["2035"]) / DemR[c]["2035"])) * (0.2 * CDisIR[c]["2030"] + 0.8 * CDisIR[c]["2035"]) * DOMSh) / discountFactorAllTime["2034"]) +  
	(((0.0 * ((elROn[c]["2030"] * (1 - DLossR[c]["2030"])) / DemR[c]["2030"]) * PopR[c]["2030"] + 1.0 * ((elROn[c]["2035"] * (1 - DLossR[c]["2035"]) * PopR[c]["2035"]) / DemR[c]["2035"])) * (0.0 * CDisIR[c]["2030"] + 1.0 * CDisIR[c]["2035"]) * DOMSh) / discountFactorAllTime["2035"]) +  
	(((0.8 * ((elROn[c]["2035"] * (1 - DLossR[c]["2035"])) / DemR[c]["2035"]) * PopR[c]["2035"] + 0.2 * ((elROn[c]["2040"] * (1 - DLossR[c]["2040"]) * PopR[c]["2040"]) / DemR[c]["2040"])) * (0.8 * CDisIR[c]["2035"] + 0.2 * CDisIR[c]["2040"]) * DOMSh) / discountFactorAllTime["2036"]) +  
	(((0.6 * ((elROn[c]["2035"] * (1 - DLossR[c]["2035"])) / DemR[c]["2035"]) * PopR[c]["2035"] + 0.4 * ((elROn[c]["2040"] * (1 - DLossR[c]["2040"]) * PopR[c]["2040"]) / DemR[c]["2040"])) * (0.6 * CDisIR[c]["2035"] + 0.4 * CDisIR[c]["2040"]) * DOMSh) / discountFactorAllTime["2037"]) +  
	(((0.4 * ((elROn[c]["2035"] * (1 - DLossR[c]["2035"])) / DemR[c]["2035"]) * PopR[c]["2035"] + 0.6 * ((elROn[c]["2040"] * (1 - DLossR[c]["2040"]) * PopR[c]["2040"]) / DemR[c]["2040"])) * (0.4 * CDisIR[c]["2035"] + 0.6 * CDisIR[c]["2040"]) * DOMSh) / discountFactorAllTime["2038"]) +  
	(((0.2 * ((elROn[c]["2035"] * (1 - DLossR[c]["2035"])) / DemR[c]["2035"]) * PopR[c]["2035"] + 0.8 * ((elROn[c]["2040"] * (1 - DLossR[c]["2040"]) * PopR[c]["2040"]) / DemR[c]["2040"])) * (0.2 * CDisIR[c]["2035"] + 0.8 * CDisIR[c]["2040"]) * DOMSh) / discountFactorAllTime["2039"]) +  
	(((0.0 * ((elROn[c]["2035"] * (1 - DLossR[c]["2035"])) / DemR[c]["2035"]) * PopR[c]["2035"] + 1.0 * ((elROn[c]["2040"] * (1 - DLossR[c]["2040"]) * PopR[c]["2040"]) / DemR[c]["2040"])) * (0.0 * CDisIR[c]["2035"] + 1.0 * CDisIR[c]["2040"]) * DOMSh) / discountFactorAllTime["2040"])   
	);

//Define objective function
dexpr float cost = CTotGenI + CTotGenOM + CTotTrI + CTotTrOM + CTotDisI + CTotDisOM;


//Solve  
minimize cost;




//***************************************Define constraints********************************************************
subject to {
//Fix binaries
//forall(p in ConnectedPlant, t in Time)
//  ctfixXGen: xGen[p][t] == xGenFix[p][t];

//forall(nel in NonExistLine, t in Time)
//  ctfixXTrans: xTrans[nel][t] == xTransFix[nel][t];
 


////*************Demand**************
//Electrification rate definition
forall(c in Cell, t in Time)
  ctRuralElectrificationRate: (((elROn[c][t] * (1 - DLossR[c][t])) + elROff[c][t]) / DemR[c][t]) == erR[c][t];

forall(c in Cell, t in Time)
  ctUrbanElectrificationRate: (((elUOn[c][t] * (1 - DLossU[c][t])) + elUOff[c][t]) / DemU[c][t]) == erU[c][t];

forall(c in Cell, t in Time)
  ctTotalElectrificationRate: ((erU[c][t] * PopU[c][t]) + (erR[c][t] * PopR[c][t])) / (PopU[c][t] + PopR[c][t]) == erTot[c][t];

forall(c in Cell, t in Time)
  ctTotalBusElecRate: (elBus[c][t] * (1 - DLossBus[c][t])) / DemBus[c][t] == erBus[c][t];


//Meet target
forall(t in Time)
  ctElectrificationRate: sum(c in Cell) ((erU[c][t] * PopU[c][t] / PopTot[t]) + (erR[c][t] * PopR[c][t] / PopTot[t])) >= ERTar[t];

//Meet non-surpressed part of total business demand
forall(t in Time)
  ctBusinessDemand: (sum(c in Cell) (erBus[c][t] * DemBus[c][t])) / (sum(c in Cell) (DemBus[c][t])) >= ERTarBus[t];

//Monotonous increase required for socio-poltical reasons

forall(c in Cell)
  ctMonotonElecRate1: erTot[c]["2025"] >= erTot[c]["2020"];

forall(c in Cell)
  ctMonotonElecRate2: erTot[c]["2030"] >= erTot[c]["2025"];

forall(c in Cell)
  ctMonotonElecRate3: erTot[c]["2035"] >= erTot[c]["2030"];

forall(c in Cell)
  ctMonotonElecRate4: erTot[c]["2040"] >= erTot[c]["2035"];


//Symmetry breaking: Assume business demand is served where urban demand is served
forall(c in Cell: c == "Kampal")
  ctBusUrb: erBus[c]["2040"] >= 0.8;


 
//Ensure meeting peak demand with minimum reserve margin
forall(t in Time)
  ctPeakDemand: sum(p in ConnectedPlant) (genCC[p][t] + ExSup[p]["2020"])  >= RM * PDemRt * (sum(c in Cell) (elUOn[c][t] * (1 - DLossU[c][t]) + elROn[c][t] * (1 - DLossR[c][t]) + elBus[c][t] * (1 - DLossBus[c][t])));



//*************Supply**************
//Total new installed capacity in MW
forall(p in Plant)
  ctinstCap2020: genCC[p]["2020"] == genCap[p]["2020"];
  
forall(p in Plant)
  ctinstCap2025: genCC[p]["2025"] == genCap[p]["2025"] + genCap[p]["2020"];
  
forall(p in Plant)
  ctinstCap2030: genCC[p]["2030"] == genCap[p]["2030"] + genCap[p]["2025"] + genCap[p]["2020"];
  
forall(p in Plant)
  ctinstCap2035: genCC[p]["2035"] == genCap[p]["2035"] + genCap[p]["2030"] + genCap[p]["2025"] + genCap[p]["2020"];
  
forall(p in Plant)
  ctinstCap2040: genCC[p]["2040"] == genCap[p]["2040"] + genCap[p]["2035"] + genCap[p]["2030"] + genCap[p]["2025"] + genCap[p]["2020"];


//Supply limit constraints in MW
forall(p in Plant)
  ctSupply2020: genCap[p]["2020"] <= Sup[p]["2020"];
  
forall(p in Plant)
  ctSupply2025: genCap[p]["2025"] <= Sup[p]["2025"] - genCC[p]["2020"];
  
forall(p in Plant)
  ctSupply2030: genCap[p]["2030"] <= Sup[p]["2030"] - genCC[p]["2025"];
  
forall(p in Plant)
  ctSupply2035: genCap[p]["2035"] <= Sup[p]["2035"] - genCC[p]["2030"];
  
forall(p in Plant)
  ctSupply2040: genCap[p]["2040"] <= Sup[p]["2040"] - genCC[p]["2035"];  
  
forall(p in ConnectedSolarPlant, t in Time)
  ctSupplySolarMaxSize: genCC[p][t] <= MaxSol;
 


//Maximum gen constraint per plant in GWh
forall(p in Plant)
  ctCapToGen2020: gen[p]["2020"] <= (genCC[p]["2020"] + ExSup[p]["2020"]) * CF[p] * 8.76;    

forall(p in Plant)
  ctCapToGen2025: gen[p]["2025"] <= (genCC[p]["2025"] + ExSup[p]["2020"]) * CF[p] * 8.76; 
  
forall(p in Plant)
  ctCapToGen2030: gen[p]["2030"] <= (genCC[p]["2030"] + ExSup[p]["2020"]) * CF[p] * 8.76; 
  
forall(p in Plant)
  ctCapToGen2035: gen[p]["2035"] <= (genCC[p]["2035"] + ExSup[p]["2020"]) * CF[p] * 8.76; 
  
forall(p in Plant)
  ctCapToGen2040: gen[p]["2040"] <= (genCC[p]["2040"] + ExSup[p]["2020"]) * CF[p] * 8.76; 



//big M constraints gen
forall(p in ConnectedPlant, t in Time)
  ctbigMGenUp: genCap[p][t] >= xGen[p][t] * MinSize[p];

forall(p in ConnectedSolarPlant, t in Time)
  //ctbigMGenDown12020: genCap[p][t] <= xGen[p][t] * MaxSol;
  ctbigMGenDown12020: genCap[p][t] <= xGen[p][t] * ((((ERTarBus[t] * (sum(c in Cell) (DemBus[c][t]))) + ERTar[t] * (sum (c in Cell) (DemU[c][t] + DemR[c][t]))) / (8.76 * CF[p])) * MaxShSol);

forall(p in ConnectedNonSolarPlant, t in Time)
  ctbigMGenDown2: genCap[p][t] <= xGen[p][t] * Sup[p][t];


//Logical constraints in gen: capacity can only be added once for all plants other than any solar plant or any technology where large-scale capacity beyond one plant per district exists
forall(p in OneTimePlant)
  ctOnceOrNever: sum(t in Time) xGen[p][t] <= 1;
  
forall(p in Plant: p == "KiryanHydro")
  ctTwiceOrOnceOrNever: sum(t in Time) xGen[p][t] <= 2;  


//Share of volatile power supply limit constraint
forall(t in Time)
  ctVolatile: sum(p in VolatilePlant) (genCC[p][t] + ExSup[p][t]) <= MaxVol * (sum(p in ConnectedPlant) (genCC[p][t] + ExSup[p][t]));  




//*************Transmisson*******************
//Total new installed capacity
forall(l in Line)
  ctinstTransCap2020: transCC[l]["2020"] == transCap[l]["2020"];
  
forall(l in Line)
  ctinstTransCap2025: transCC[l]["2025"] == transCap[l]["2025"] + transCap[l]["2020"];
  
forall(l in Line)
  ctinstTransCap2030: transCC[l]["2030"] == transCap[l]["2030"] + transCap[l]["2025"] + transCap[l]["2020"];
  
forall(l in Line)
  ctinstTransCap2035: transCC[l]["2035"] == transCap[l]["2035"] + transCap[l]["2030"] + transCap[l]["2025"] + transCap[l]["2020"];
  
forall(l in Line)
  ctinstTransCap2040: transCC[l]["2040"] == transCap[l]["2040"] + transCap[l]["2035"] + transCap[l]["2030"] + transCap[l]["2025"] + transCap[l]["2020"];


//Transmission cannot exceed capacity
forall(ldir in TransLine, t in Time)    
  ctTransCap: trans[ldir][t] <= sum(l in Line) (TransLinePairMatch[l][ldir] * (transCC[l][t] + ExTr[l]) * CFTrans * 8.76);
      
    
//Ensure that new capacity is actually connected to the grid using shortest path to the grid
forall(p in ConnectedPlantNotconnectedDistrict, nel in NonExistLine)
	xTrans[nel]["2020"] >= xGen[p]["2020"] * SPGrid[p][nel];	

forall(p in ConnectedPlantNotconnectedDistrict, nel in NonExistLine)
		xTrans[nel]["2025"] + xTrans[nel]["2020"] >= xGen[p]["2025"] * SPGrid[p][nel];
	
forall(p in ConnectedPlantNotconnectedDistrict, nel in NonExistLine)
		xTrans[nel]["2030"] + xTrans[nel]["2025"] + xTrans[nel]["2020"] >= xGen[p]["2030"]  * SPGrid[p][nel];
	
forall(p in ConnectedPlantNotconnectedDistrict, nel in NonExistLine)
		xTrans[nel]["2035"] + xTrans[nel]["2030"] + xTrans[nel]["2025"] + xTrans[nel]["2020"] >= xGen[p]["2035"]  * SPGrid[p][nel];
	
forall(p in ConnectedPlantNotconnectedDistrict, nel in NonExistLine)
		xTrans[nel]["2040"] + xTrans[nel]["2035"] + xTrans[nel]["2030"] + xTrans[nel]["2025"] + xTrans[nel]["2020"] >= xGen[p]["2040"] * SPGrid[p][nel];





//big M constraints transmission

forall(nel in NonExistLine, t in Time)
    ctbigMTransUp: transCap[nel][t] >= xTrans[nel][t] * MinTransLine;

forall(nel in NonExistLine, t in Time)
    ctbigMTransDown: transCap[nel][t] <= xTrans[nel][t] * ((((ERTarBus["2040"] * (sum(c in Cell) (DemBus[c]["2040"]))) + ERTar["2040"] * (sum (c in Cell) (DemU[c]["2040"] + DemR[c]["2040"]))) / (8.76 * CFTrans)) * MaxTransLine);


  
//It cannot be optimal to build a transmission TransLine and then later upgrade it to higher MW as this would burn capital
forall(nel in NonExistLine)
  ctDirectionTrans: sum(t in Time) (xTrans[nel][t]) <= 1;
  
//Transmission TransLines built cannot exceed certain cummulative length 
//forall(t in Time)
//  ctDistanceKnapsack: sum(nel in NonExistLine) (xTrans[nel][t] * Len[nel] * nonBeeTransLine) <= cumTransLineLengthMax;

  
//***********************Distribution************************
//Restrict distribution network to maximally serve what it is already serving and to only those districts without transmission TransLines
forall(c in NonConnectedCell, t in Time)
  ctDistrNetworkBalance: (sum(d in TransLine) ((sum(l in Line) (TransLinePairMatch[l][d] * transD[d][t] * ExTrD[l])) * energyBalanceFactorTransIn[c][d] * DLoss[d])) - (sum(d in TransLine) ((sum(l in Line) (TransLinePairMatch[l][d] * transD[d][t] * ExTrD[l])) * energyBalanceFactorTransOut[c][d])) == disR[c][t] + disU[c][t] + disBus[c][t];   

forall(c in ConnectedCell, t in Time)
  ctDistrCon1: disR[c][t] == 0;
  
forall(c in ConnectedCell, t in Time)
  ctDistrCon2: disU[c][t] == 0;
  
forall(c in ConnectedCell, t in Time)
  ctDistrCon3: disBus[c][t] == 0;

forall(d in TransLine, t in Time)
if (sum(l in Line) (TransLinePairMatch[l][d] * ExTr[l]) > 0.1) {
		cttransDLimitCC: transD[d][t] == 0; 	
	}  
   
  
//Upper bound on distribution network between cells: No more inter-district 33 kV distribution TransLines, valid assumption if minimum distance between 2 districts is over 10 km as in that case, its always cheaper to build transmission TransLines at 132 kV 
forall(c in NonConnectedCell, t in Time)  
  ctDistrLimitBusiness: disBus[c][t] * (1 - DLossBus[c][t]) <= ExBus[c][t];
 
forall(c in NonConnectedCell, t in Time)  
  ctDistrLimitUrb: disU[c][t] * (1 - DLossU[c][t]) <= ExUOn[c][t];

forall(c in NonConnectedCell, t in Time)  
  ctDistrLimitRur: disR[c][t] * (1 - DLossR[c][t]) <= ExROn[c][t];


//The following set of constraints is redundant to the one on monotonous electricity rate increase in the optimal solution 
forall(c in Cell)
  ctTempWithinUrb1: elUOn[c]["2025"] >= elUOn[c]["2020"];

forall(c in Cell)
  ctTempWithinUrb2: elUOn[c]["2030"] >= elUOn[c]["2025"];

forall(c in Cell)
  ctTempWithinUrb3: elUOn[c]["2035"] >= elUOn[c]["2030"];
  
forall(c in Cell)
  ctTempWithinUrb4: elUOn[c]["2040"] >= elUOn[c]["2035"];
  
    
forall(c in Cell)
  ctTempWithinRur1: elROn[c]["2025"] >= elROn[c]["2020"];

forall(c in Cell)
  ctTempWithinRur2: elROn[c]["2030"] >= elROn[c]["2025"];

forall(c in Cell)
  ctTempWithinRur3: elROn[c]["2035"] >= elROn[c]["2030"];
  
forall(c in Cell)
  ctTempWithinRur4: elROn[c]["2040"] >= elROn[c]["2035"];
    

forall(c in Cell)
  ctTempWithinUrbOff1: elUOff[c]["2025"] >= elUOff[c]["2020"];

forall(c in Cell)
  ctTempWithinUrbOff2: elUOff[c]["2030"] >= elUOff[c]["2025"];

forall(c in Cell)
  ctTempWithinUrbOff3: elUOff[c]["2035"] >= elUOff[c]["2030"];
  
forall(c in Cell)
  ctTempWithinUrbOff4: elUOff[c]["2040"] >= elUOff[c]["2035"];
  
    
forall(c in Cell)
  ctTempWithinRurOff1: elROff[c]["2025"] >= elROff[c]["2020"];

forall(c in Cell)
  ctTempWithinRurOff2: elROff[c]["2030"] >= elROff[c]["2025"];

forall(c in Cell)
  ctTempWithinRurOff3: elROff[c]["2035"] >= elROff[c]["2030"];
  
forall(c in Cell)
  ctTempWithinRurOff4: elROff[c]["2040"] >= elROff[c]["2035"];

//Lower and upper bound on grid and off-grid connected electricity for each cell individually
  //Lower bound: always meet existing demand
forall(c in Cell, t in Time)
  ctExistBusiness: elBus[c][t] * (1 - DLossBus[c][t]) >= ExBus[c][t];

forall(c in Cell, t in Time)
  ctExistDemUOn: elUOn[c][t] * (1 - DLossU[c][t]) >= ExUOn[c][t];

forall(c in Cell, t in Time)
  ctExistDemUOff: elUOff[c][t] >= ExUOff[c][t];

forall(c in Cell, t in Time)
  ctExistDemROn: elROn[c][t] * (1 - DLossR[c][t]) >= ExROn[c][t];
  
forall(c in Cell, t in Time)
  ctExistDemROff: elROff[c][t] >= ExROff[c][t];
 
  //Upper bound: dont exceed demand in any cell
forall(c in Cell, t in Time)
  ctNotExceedBusinessDemand: elBus[c][t] * (1 - DLossBus[c][t]) <= DemBus[c][t];

forall(c in Cell, t in Time)
  ctNotExceedUrbanDemand: elUOn[c][t] * (1 - DLossU[c][t]) + elUOff[c][t] <= DemU[c][t];

forall(c in Cell, t in Time)
  ctNotExceedRuralDemand: elROn[c][t] * (1 - DLossR[c][t]) + elROff[c][t] <= DemR[c][t];


//*************Energy balances for all cells**************
//Transmission In = Transmission Out
forall(c in Cell, t in Time)
  ctEnergyBalanceTrans: (sum(ldir in TransLine) (trans[ldir][t] * energyBalanceFactorTransIn[c][ldir] * TLoss[ldir])) + (elUp[c][t] * CLkV)
  						== (sum(ldir in TransLine) (trans[ldir][t] * energyBalanceFactorTransOut[c][ldir])) + elDown[c][t];

//Distribution In = Distribution Out
forall(c in Cell, t in Time)
ctEnergyBalanceDistr: (sum(p in ConnectedPlant) (gen[p][t] * GenEff * districtPlantMatch[c][p])) + (sum(d in TransLine) ((sum(l in Line) (TransLinePairMatch[l][d] * transD[d][t] * ExTrD[l])) * energyBalanceFactorTransIn[c][d] * DLoss[d])) + (elDown[c][t] * CLkV)
  						== (sum(d in TransLine) ((sum(l in Line) (TransLinePairMatch[l][d] * transD[d][t] * ExTrD[l])) * energyBalanceFactorTransOut[c][d])) + elUp[c][t] + elBus[c][t] + elUOn[c][t] + elROn[c][t];

//Off grid balance
forall(c in Cell, t in Time)
  ctOffGridBalance: sum(p in OffGridPlant) (gen[p][t] * districtPlantMatch[c][p]) == elUOff[c][t] + elROff[c][t];

  

   
//*********Multi-criteria constraints*************
//Meet minimum electrification equality constraint
forall(c1,c2 in Cell: c1 != c2, t in Time: t != "2020" && t != "2040")
  ctRegIneqDom1: erTot[c1][t] - erTot[c2][t] <= 1 - 0.5 * eps_reg;

forall(c1,c2 in Cell: c1 != c2, t in Time: t == "2040")
  ctRegIneqDom2: erTot[c1][t] - erTot[c2][t] <= 1 - eps_reg;

/*forall(c1,c2 in Cell: c1 != c2 && c1 !="Kampala" && c1 != "Wakiso", t in Time: t == "2040")
  ctRegIneqBus1: erBus[c1][t] - erBus[c2][t] <= 1 - eps_reg;
*/

forall(c in Cell: c != "Kampal", t in Time: t != "2020" && t != "2040")
  ctUrbRurEq1a: erU[c][t] - erR[c][t] <= 1 - 0.5 * eps_urbrur;

forall(c in Cell: c != "Kampal", t in Time: t == "2040")
  ctUrbRurEq2a: erU[c][t] - erR[c][t] <= 1 - eps_urbrur;
  
forall(c in Cell: c != "Kampal", t in Time: t != "2020" && t != "2040")
  ctUrbRurEq1b: erR[c][t] - erU[c][t] <= 1 - 0.5 * eps_urbrur;
  
forall(c in Cell: c != "Kampal", t in Time: t == "2040")
  ctUrbRurEq2b: erR[c][t] - erU[c][t] <= 1 - eps_urbrur;
  
  
//Emission maximum in 2040
//forall(t in Time: t == "2040")
 //	ctCO2Em: sum(c in Cell, g in GenTech, t in Time) ((gen[c][g][t] + existgen[c][g][t]) * CO2Em[g]) <= eps_em * (sum(c in Cell, g in GenTech, t in Time) ((gen[c][g][t] + existgen[c][g][t]) * CO2Em["Oil"]));

}




//************************Post estimation calculations for data export to Excel***************************************
execute {
	var after = new Date();
	writeln("solving time ~= ",after.getTime()-temp);
		}


float genLong[PlantXTime];
int res = 1;
execute {
	for (var p in Plant) {
		for (var t in Time) {		
			genLong[res] = gen[p][t];
			res = res + 1; 		
    	}}}

float genCCLong[PlantXTime];
int res99 = 1;
execute {
	for (var p in Plant) {
		for (var t in Time) {		
			genCCLong[res99] = genCC[p][t];
				res99 = res99 + 1; 		
    	}}}


float xGenLong[ConnectedPlantXTime];
int res999 = 1;
execute {
	for (var p in ConnectedPlant) {
		for (var t in Time) {		
			xGenLong[res999] = xGen[p][t];
				res999 = res999 + 1; 		
    	}}}

float transLong[TransLineXTime];
int res3 = 1;
execute {
	for (var ldir in TransLine) {
		for (var t in Time) {		
			transLong[res3] = trans[ldir][t];
			res3 = res3 + 1; 		
    	}}}

float transDLong[TransLineXTime];
int res33 = 1;
execute {
	for (var d in TransLine) {
		for (var t in Time) {		
			transDLong[res33] = transD[d][t];
			res33 = res33 + 1; 		
    	}}}


float transCCLong[LineXTime];
int res4 = 1;
execute {
	for (var l in Line) {
		for (var t in Time) {		
			transCCLong[res4] = transCC[l][t];
			res4 = res4 + 1; 		
    	}}}
    	
float xTransLong[NonExistLineXTime];
int res44 = 1;
execute {
	for (var nel in NonExistLine) {
		for (var t in Time) {		
			xTransLong[res44] = xTrans[nel][t];
			res44 = res44 + 1; 		
    	}}}


    	
float elUpLong[CellXTime];
int res8 = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {		
			elUpLong[res8] = elUp[c][t];
			res8 = res8 + 1; 		
    	}}}
    	
float elDownLong[CellXTime];
int res9 = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {		
			elDownLong[res9] = elDown[c][t];
			res9 = res9 + 1; 		
    	}}}


float elBusLong[CellXTime];
int res10 = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {		
			elBusLong[res10] = elBus[c][t];
			res10 = res10 + 1; 		
    	}}}

float elUOnLong[CellXTime];
int res11 = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {		
			elUOnLong[res11] = elUOn[c][t];
			res11 = res11 + 1; 		
    	}}}

float elROnLong[CellXTime];
int res12 = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {		
			elROnLong[res12] = elROn[c][t];
			res12 = res12 + 1; 		
    	}}}
    	
float elUOffLong[CellXTime];
int res13 = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {		
			elUOffLong[res13] = elUOff[c][t];
			res13 = res13 + 1; 		
    	}}}

float elROffLong[CellXTime];
int res14 = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {		
			elROffLong[res14] = elROff[c][t];
			res14 = res14 + 1; 		
    	}}}


float disRLong[CellXTime];
int res15 = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {		
			disRLong[res15] = disR[c][t];
			res15 = res15 + 1; 		
    	}}}    	

float disULong[CellXTime];
int res16 = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {		
			disULong[res16] = disU[c][t];
			res16 = res16 + 1; 		
    	}}} 
    	
float disBusLong[CellXTime];
int res17 = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {		
			disBusLong[res17] = disBus[c][t];
			res17 = res17 + 1; 		
    	}}} 
    	
string namePath = "Results!A";


float erULong[CellXTime];
int res171 = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {		
			erULong[res171] = erU[c][t];
			res171 = res171 + 1; 		
    	}}}

float erRLong[CellXTime];
int res172 = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {		
			erRLong[res172] = erR[c][t];
			res172 = res172 + 1; 		
    	}}}
    	
float erTotLong[CellXTime];
int res173 = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {		
			erTotLong[res173] = erTot[c][t];
			res173 = res173 + 1; 		
    	}}}
    	
float erBusLong[CellXTime];
int res174 = 1;
execute {
	for (var c in Cell) {
		for (var t in Time) {		
			erBusLong[res174] = erBus[c][t];
			res174 = res174 + 1; 		
    	}}}


execute concatene {
	namePath += indexPoint;
	namePath += ":CNW";
	namePath += indexPoint;
}









