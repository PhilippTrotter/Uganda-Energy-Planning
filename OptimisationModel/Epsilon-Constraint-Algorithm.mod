/*********************************************
 * OPL 12.6.3.0 Data
 * Author: pt428
 * Creation Date: 24 May 2018 at 11:23:58
 *********************************************/

//Epsilon constraint algorithm with fixed step size of k = 1/3 (i.e. total of 4*4=16 MILP soltions) - see explanation in paper 
 main {
  var source = new IloOplModelSource("Uganda-Energy-Planning-final.mod");
  var cplex = new IloCplex();
  var def = new IloOplModelDefinition(source);
  var opl = new IloOplModel(def,cplex);
  var data = new IloOplDataSource("Uganda-Data-10-District-case-final.dat");
  var result = new IloOplOutputFile("201811108_resultUganda10Dis.csv");
  var resultXTrans11 = new IloOplOutputFile("20181025_resultXTrans11_10Dis.csv");
  var resultXGen11 = new IloOplOutputFile("20181025_resultXGen11_10Dis.csv");
  var resultXTrans0606 = new IloOplOutputFile("20181025_resultXTrans0606_10Dis.csv");
  var resultXGen0606 = new IloOplOutputFile("20181025_resultXGen0606_10Dis.csv");
  var resultXTrans00 = new IloOplOutputFile("20181025_resultXTrans00_10Dis.csv");
  var resultXGen00 = new IloOplOutputFile("20181025_resultXGen00_10Dis.csv");
  
  
  var iterCountLocal = 0;
  var iterCountGlobal = 0;
  
  var curString = "Result_"; 
  var curStringPrev = "Result_";
  var namePath = "Result_67_33.mst";
  var namePathPrev = "";  
  var currentMergedMST = "";
  var UrbRurIndPrev = 1;
  var UrbRurIndPrevSc = 100;
  
   // Merge multiple MST files into one - code courtesy of Daniel Junglas.
   // FILES is an array of string with the names of the files to be merged.
   // OUT is the name of the output file
   function mergeMST(files, out) {
     var output = new IloOplOutputFile(out);
     for (var i = 0; i < files.length; ++i) {
       var input = new IloOplInputFile(files[i]);
       var inheader = true;
       var inbody = false;
       while (!input.eof) {
         var line = input.readline();
         if (line.indexOf("<CPLEXSolutions") >= 0) { // Start of a set of MIP starts
           if (i == 0)
             output.writeln(line);
           inheader = false;
           inbody = true;  
         }
         else if (line.indexOf("</CPLEXSolutions") >= 0) { // End of a set of MIP starts
           if (i == files.length - 1)
             output.writeln(line);
           inbody = false;           
         }
         else {
            if (inheader && i == 0) // copy header from first file
              output.writeln(line);            
            else if (inbody)
              output.writeln(line); // copy body from any file
            else if (!inheader && !inbody && i == files.length - 1) // copy trailer from last file
              output.writeln(line);                  
         }   
       }
       input.close();
     }      
     output.close();
   }
    
    
    //Implement epsilon constraint algorithm: loop through both epsilons
  for(var UrbRurInd=1;UrbRurInd>-0.1;UrbRurInd=UrbRurInd-0.3333333) {
  	iterCountLocal = 0; 	
  	  	
  	for(var EqualityInd=1;EqualityInd>-0.1;EqualityInd=EqualityInd-0.3333333) {
		
		//initialise data for optimisation model instance
		if (iterCountGlobal > -0.1) {
			var UrbRurIndSc = Opl.round(UrbRurInd * 100);
			var EqualityIndSc = Opl.round(EqualityInd * 100);
			var opl = new IloOplModel(def,cplex);
			iterCountLocal = iterCountLocal + 1;
			iterCountGlobal = iterCountGlobal + 1; 
	        var data2 = new IloOplDataElements();
		  	data2.eps_reg = EqualityInd;
			data2.eps_urbrur = UrbRurInd;
			data2.indexPoint = iterCountGlobal;
			opl.addDataSource(data);
		  	opl.addDataSource(data2);
		 		
		 	opl.generate();
		
		//Set optimisation termination parameters	
		cplex.tilim = 86400;
		cplex.mipdisplay = 3;
		cplex.epgap = 0;
			
			//Load correct MIP Starts dependent on current iteration
			if (iterCountGlobal > 1.1) {
				if (iterCountLocal > 1.1) {
					if (UrbRurInd < 0.7) {
						if (UrbRurInd > 0.4) {
						UrbRurIndPrevSc = 100;
		 				}
		 				if (UrbRurInd > 0.2 && UrbRurInd < 0.4) {
						UrbRurIndPrevSc = 67;
		 				}
		 				if (UrbRurInd < 0.1) {
						UrbRurIndPrevSc = 33;
		 				}			
		 				curStringPrev = "Result_"; 	
						namePathPrev = "C:/Users/pt428/Desktop/PhD/01 Papers/Uganda elec planning/Cplex/UgandaOptBin";
						//namePathPrev = "";
						curStringPrev += UrbRurIndPrevSc;
						curStringPrev += "_";
						curStringPrev += EqualityIndSc;
						namePathPrev += curStringPrev;
						namePathPrev += ".mst";
						currentMergedMST = "C:/Users/pt428/Desktop/PhD/01 Papers/Uganda elec planning/Cplex/UgandaOptBin";
						//currentMergedMST = "";
						currentMergedMST += "MergeFor";
						currentMergedMST += UrbRurIndSc;
						currentMergedMST += "_";
						currentMergedMST += EqualityIndSc;
						currentMergedMST += ".mst";
			    		mergeMST(new Array(namePath, namePathPrev), currentMergedMST);
			    		cplex.readMIPStarts(currentMergedMST);
					}
					if (UrbRurInd > 0.7) {			
						cplex.readMIPStarts(namePath);	
		  			}
	    		} else {
	    			curStringPrev = "Result_"; 	
					namePathPrev = "C:/Users/pt428/Desktop/PhD/01 Papers/Uganda elec planning/Cplex/UgandaOptBin";
					//namePathPrev = "";
					curStringPrev += UrbRurIndPrevSc;
					curStringPrev += "_";
					curStringPrev += EqualityIndSc;
					namePathPrev += curStringPrev; 
					cplex.readMIPStarts(namePathPrev);  		
	    		}	  			
	   		}
			
			//Test how many initial solutions were used		
			writeln(UrbRurInd + ";" + EqualityInd + " No of MIP starts provided: " + cplex.getNMIPStarts());
					
			//Update string for MIP Start write
			curString = "Result_"; 	
			namePath = "C:/Users/pt428/Desktop/PhD/01 Papers/Uganda elec planning/Cplex/UgandaOptBin";
			curString += UrbRurIndSc;
			curString += "_";
			curString += EqualityIndSc;
			namePath += curString;
		    namePath += ".mst"
	      	
	      	//Solve MILP instance		
			if (cplex.solve()) {
		    	//write solution as initial solution for next iteration
		    	cplex.writeMIPStarts(namePath,0,1);
		    	opl.postProcess();
		     	result.writeln(UrbRurInd + ";" + EqualityInd + ";" + cplex.getObjValue()); 
		     	var relGap = (cplex.getObjValue() - cplex.getBestObjValue()) / cplex.getObjValue();
		     	writeln(UrbRurInd + ";" + EqualityInd + " gap: " + relGap + " Obj Value: " + cplex.getObjValue() + " Best value: " + cplex.getBestObjValue());
		     	//result.writeln(opl.printSolution());
		     	if(UrbRurInd > 0.9) {
		     		if(EqualityInd > 0.9){
		     			resultXTrans11.writeln(opl.xTrans.solutionValue);
		     			resultXGen11.writeln(opl.xGen.solutionValue);	     		
		     		} 	
		     	}
		     	if(UrbRurInd < 0.7 && UrbRurInd > 0.6) {
		     		if(EqualityInd < 0.7 && EqualityInd > 0.6){
		     			resultXTrans0606.writeln(opl.xTrans.solutionValue);
		     			resultXGen0606.writeln(opl.xGen.solutionValue);	     		
		     		} 	
		     	}
		     	if(UrbRurInd < 0.1) {
		     		if(EqualityInd < 0.1){
		     			resultXTrans00.writeln(opl.xTrans.solutionValue);
		     			resultXGen00.writeln(opl.xGen.solutionValue);	     		
		     		} 	
		     	}
		     	
		  	} else {
		    	writeln("No solution");
		  	}
			
			data2.end();
	 		opl.end();
	 		
		} else {
		iterCountGlobal = iterCountGlobal + 1;
		iterCountLocal = iterCountLocal + 1;		 		
	}
}  
}
}
