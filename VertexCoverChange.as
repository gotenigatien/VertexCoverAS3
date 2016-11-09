package  {
	
	public class VertexCoverChange  {
		
		//var v:Vector.<int> = new Vector.<String>();
		
		//vector< vector<int> > graph;
		public var graph:Array = new Array();
		public var vcovers:Array = new Array();
		
		public var ocovers:Array=new Array();
		public var n:int;
		
		public function VertexCoverChange() {
			// constructor code
		}
		public function tryV(){
			n = 4;
			graph[0]=[0,1,1,0];
			graph[1]=[1,0,0,1];
			graph[2]=[1,0,0,1];
			graph[3]=[0,1,1,0];
			findVertex(1);
		}
		public function tryBad(){
			vcovers[0]=[2,3,4,5];
			vcovers[1]=[2,3,6,2];
			vcovers[2]=[1,5,4,1,2];
			vcovers[3] = [7, 5, 4, 1, 28, 9];
			vcovers[4]=[2,3,4,5];
			vcovers[5]=[6,1,5,7];
			vcovers[6] = [4, 5, 4, 1, 28, 9];
			traceResult(vcovers);
			clearDouble();
			trace("-----------");
			traceResult(vcovers);
		}
		public function traceResult(tab:Array){
			var s:String = new String();
			for (var i:int = 0; i < tab.length; i++ ){
				for (var j:int = 0;j < tab[i].length; j++ ){
					s = s + " " + tab[i][j];
				}
				trace("Scenario ("+tab[i].length+") "+(i+1)+" -> "+s); s = "";
			}
		}
		
		public function clearDouble(){
			var ss:int = 0;
			var sb:int = 0;
			var i:int = 0, j:int = 0, k:int = 0;
			var minC:int;
			var a:Array = new Array();
			var sk:String = new String();
			var ncovers:Array = new Array();
			var kcovers:Array = new Array();
			minC = vcovers[0].length;
			for (i= 0; i < vcovers.length; i++ ){
				if (minC > vcovers[i].length) minC = vcovers[i].length;
			}
			for (i = 0; i < vcovers.length; i++ ){
				if (minC == vcovers[i].length) kcovers.push(vcovers[i]);
			}
			vcovers = kcovers;
			vcovers.sort();
			ncovers.push(vcovers[0]);
			
			for (i = 0; i < vcovers.length; i++ ){
				for (j = 0; j < ncovers.length; j++ ){
					for (k = 0; k < vcovers.length;k++ ){
						if (vcovers[i][k] == ncovers[j][k]) ss++;
					}
					if (ss == vcovers.length) sb++;
					ss = 0;
				}
				if (sb == 0) ncovers.push(vcovers[i]);
				sb = 0;
			}
			
			vcovers = ncovers;
			
		}
		
		public function findVertex(k:int){
			var i:int=0, j:int=0, p:int=0, q:int=0, r:int=0, s:int=0, min:int=0, edge:int=0, counter:int = 0;
			var neighbors:Array = new Array();
			var st:String = "";
			var found:Boolean = false;
			vcovers = [];
			//Find Neighbors
			for(i=0; i<n; i++){
				var neighbor:Array=new Array();
				for(j=0; j<n; j++){
					if (graph[i][j] == 1) neighbor.push(j);
				}
				neighbors.push(neighbor);
			}
			
			
			//Read minimum size of Vertex Cover wanted
			var found:Boolean=false;
			min=n+1;
			var covers:Array=new Array();
			var allcover:Array = new Array();
			  
			  //--------------------------------------------------------------
			for(i=0; i<n; i++){
				allcover.push(1);
			}
			for(i=0; i<n; i++){
				if(found) break;
				counter++; 
				var cover:Array = new Array();
				for(var i2:int=0; i2<allcover.length; i2++){
					cover.push(1);
				}
				cover[i] = 0;
				cover=procedure_1(neighbors,cover);
				s = cover_size(cover);
				if(s<min) min=s;
				if (s <= k){
					var vcover:Array = new Array();
					for (j = 0; j < cover.length; j++) {
						if (cover[j] == 1) {
							st = st + (j + 1) + " ";
							vcover.push(j+1);
					   }
				   }
				   //trace(counter + ". Vertex Cover (" + s + "): " + st);
				   st = "";
				   vcovers.push(vcover);
				   covers.push(cover);
				   found=true;
				   break;
				}
				
				for(j=0; j<n-k; j++){
					cover=procedure_2(neighbors,cover,j);
				}
				s=cover_size(cover);
				if(s<min) min=s;
				var vcover:Array = new Array();
				for (j = 0; j < cover.length; j++) {
					if (cover[j] == 1)  {
						st = st + (j + 1) + " ";
						vcover.push(j+1);
					}			  
				}
				//trace(counter+". Vertex Cover (" + s + "): "+st);
				st = "";
				vcovers.push(vcover);
				covers.push(cover);
				if (s <= k){ 
					found = true; 
					break;
				}
			}
			  //--------------------------------------------------------------
			//Pairwise Unions
			for (p = 0; p < covers.length; p++){
				if (found) break;
				for(q=p+1; q<covers.length; q++){
					if(found) break;
					counter++; 
					var cover:Array = new Array();
					for(var i2:int=0; i2<allcover.length; i2++){
						cover.push(1);
					}
					for(r=0; r<cover.length; r++){
						if (covers[p][r] == 0 && covers[q][r] == 0) cover[r] = 0;
					}
					cover=procedure_1(neighbors,cover);
					s=cover_size(cover);
					if(s<min) min=s;
					if(s<=k){
						var vcover:Array = new Array();
						for (j = 0; j < cover.length; j++) {
							if (cover[j] == 1) {
							st = st + (j + 1) + " ";
							vcover.push(j+1);
							}
						}
						//trace(counter+". Vertex Cover (" + s + "): "+st);
						st = "";
						vcovers.push(vcover);
						found=true;
						break;
					}
					for(j=0; j<k; j++){
						cover = procedure_2(neighbors, cover, j);
					}
					s=cover_size(cover);
					if(s<min) min=s;
					var vcover:Array = new Array();
					for (j = 0; j < cover.length; j++) {
						if (cover[j] == 1) {
							st = st + (j + 1) + " ";
							vcover.push(j+1);
						}
					}
					//trace(counter+". Vertex Cover (" + s + "): "+st);
					st = "";
					vcovers.push(vcover);
					if(s<=k){ found=true; break; }
				}
			}
			 
			if(found) trace("Found Vertex Cover of size at most "+k+".");
			else {
				trace("Could not find Vertex Cover of size at most " + k + ".");
				trace("Minimum Vertex Cover size found is " + min + ".");
			}	
			clearDouble();
			traceResult(vcovers);
			
		}
		
		private function removable(neighbor:Array, cover:Array):Boolean{//return Boolean
			 var check:Boolean=true;
			 for(var i:int=0; i<neighbor.length; i++)
			 if(cover[neighbor[i]]==0)
			 {
			  check=false;
			  break;
			 }
			 return check;
			}
			
		private function max_removable(neighbors:Array, cover:Array):int{
			var r:int=-1, max:int=-1;
			for(var i:int=0; i<cover.length; i++){
				if(cover[i]==1 && removable(neighbors[i],cover)==true){
					var temp_cover:Array=cover;
					temp_cover[i]=0;
					var sum:int=0;
					for (var j:int = 0; j < temp_cover.length; j++){
						if (temp_cover[j] == 1 && removable(neighbors[j], temp_cover) == true){
							sum++;
						}
					}
					if(sum>max){
						if(r==-1){
							max=sum;
							r=i;
						}
						else if(neighbors[r].length>=neighbors[i].length){
							max=sum;
							r=i;
						}
					}
				}
			}
			return r;
		}
				
				
		private function procedure_1(neighbors:Array, cover:Array):Array{
			var temp_cover:Array=cover;
			var r:int=0;
			while(r!=-1){
				r= max_removable(neighbors,temp_cover);
				if(r!=-1) temp_cover[r]=0;
			}
			return temp_cover;
		}
			
		private function procedure_2(neighbors:Array, cover:Array, k:int):Array{
			var count:int=0;
			var temp_cover:Array=cover;
			var i:int=0;
			var j:int=0;
			for( i=0; i<temp_cover.length; i++){
				if(temp_cover[i]==1){
					var sum:int=0, index:int;
					for (j = 0; j < neighbors[i].length; j++){
						if (temp_cover[neighbors[i][j]] == 0) {
							index = j; 
							sum++;
						}
					}
					if(sum==1 && cover[neighbors[i][index]]==0){
						temp_cover[neighbors[i][index]]=1;
						temp_cover[i]=0;
						temp_cover=procedure_1(neighbors,temp_cover);
						count++;
					}
					if(count>k) break;
				}
			}
			return temp_cover;
		}
			
		private function cover_size(cover:Array):int{
			var count:int = 0;
			for (var i:int = 0; i < cover.length; i++){
				if(cover[i]==1) count++;
			}
			return count;
		}
		
	}
	
}
