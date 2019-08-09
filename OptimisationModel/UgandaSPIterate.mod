/*********************************************
 * OPL 12.6.3.0 Data
 * Author: pt428
 * Creation Date: 24 May 2018 at 11:23:58
 *********************************************/



main {
  var source = new IloOplModelSource("UgandaShortestPathSmall.mod");
  var cplex = new IloCplex();
  var def = new IloOplModelDefinition(source);
  var opl = new IloOplModel(def,cplex);
  var data = new IloOplDataSource("UgandaShortestPathSmall.dat");
  var result = new IloOplOutputFile("newResultUgandaSP.csv");
  //opl.addDataSource(data);
  
  var i = 0;
  
  for(var start=1;start<77.1;start=start+1)
  	{
  	for(var end=78;end<112.1;end=end+1)
  		{
	  		var opl = new IloOplModel(def,cplex);
	     	i = i + 1;
	 		var data2 = new IloOplDataElements();
	  		data2.currentStart = start;
			data2.currentEnd = end;
			data2.indexPoint = i;
			opl.addDataSource(data);
	  		opl.addDataSource(data2);
	 
	  		opl.generate();
	
	  		if (cplex.solve()) {
	     		opl.postProcess();
	     		result.writeln(start + ";" + end + ";" + cplex.getObjValue());
	     		writeln(start + ";" + end);
	  		} else {
	     		writeln("No solution");
	  		}
			data2.end();
	 		opl.end();
 		}
	}  
 
}