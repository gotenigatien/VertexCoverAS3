package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import ImageUploader;
	import Pannel;
	import flash.events.MouseEvent;
	import VertexCoverChange;
	import flash.filters.GlowFilter;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import Math;
	
	public class BigTitle extends MovieClip {
		private var imguploader:ImageUploader = new ImageUploader();
		private var pannel:Pannel = new Pannel();
		private var txtFont:Font = new Font();
		private var infoFormat:TextFormat = new TextFormat();
		private var dataFormat:TextFormat = new TextFormat();
		private var infoField:TextField = new TextField();
		private var dataField:TextField = new TextField();
		private var vertexNumField:TextField = new TextField();
		private var itxt:Array = new Array();
		private var dtxt:Array = new Array();
				
		private var nodesLayer:Sprite = new Sprite();
		private var linksLayer:Sprite = new Sprite();	
		
		private var NodesArray:Array = new Array();
		private var LinksArray:Array = new Array();
		private var networkarray:Array = new Array();
		private	var colornodes:Array = new Array();
		private	var colorlinks:Array = new Array();
		private var attackPlans:Array = new Array();	
		private var attackScenarios:Array = new Array();	
		private var mode:int = 0;
		private var nnodes:int = 0;
		private var i:Number;
		private var j:Number;
		private var kcolor:int=0;
		private var glowFilter1:GlowFilter = new GlowFilter(0x000000, 1, 3, 3, 10, 1);
		private var glowFilter2:GlowFilter = new GlowFilter(0x000000, 1, 1, 1, 10, 1);
		private var glowVertex:GlowFilter = new GlowFilter(0x34dd00, 1, 6, 6, 10, 1);
		private var current_node:String = "";
		private var vertexCC:VertexCoverChange = new VertexCoverChange();
		
		public function BigTitle() {
			// constructor code
			pannel.x = 870;
			vertexNumField.x = 922.5;
			vertexNumField.y = 20 + 39;
			imguploader.x = 30;
			imguploader.y = pannel.y = 20;
			infoFormat.size = dataFormat.size = 14;
			infoFormat.bold = true;
			infoFormat.font = dataFormat.font = "Calibri";
			infoFormat.align =TextFormatAlign.CENTER;
			dataFormat.align  =TextFormatAlign.CENTER;
			infoFormat.font = txtFont.fontName;			
			dataFormat.font = txtFont.fontName;
			infoField.defaultTextFormat = infoFormat;
			dataField.defaultTextFormat = dataFormat;
			vertexNumField.defaultTextFormat = infoFormat;
			infoField.border = dataField.border = true;
			infoField.borderColor = dataField.borderColor = 0xffffff;
			infoField.width = dataField.width = 276;
			infoField.height = 30;
			infoField.x = dataField.x = pannel.x;
			infoField.y = 450;
			dataField.height = 60;
			infoField.wordWrap =dataField.wordWrap = true;
			dataField.y = infoField.y + infoField.height;
			infoField.text = "Vertex Cover AS3 Program";
			itxt.push("Vertex Cover AS3 Program"," - Mode Réseau"," - Mode Attaque"," - Mode Défense");
			dtxt.push("Créez votre réseau et lancez le calcul de la matrice réseau.","Matrice réseau crée. Vous pouvez lancer le Vertex Cover.","Scénario(s) de Vertex Cover = ","Attaque du réseau terminée","Point(s) Critique(s) à défendre");
			
			infoField.text = itxt[0];
			dataField.text = dtxt[0];
			
			addChild(imguploader);
			addChild(linksLayer);
			addChild(nodesLayer);
			addChild(vertexNumField);
			addChild(pannel);
			addChild(infoField);
			addChild(dataField);
			addListenerToPannel();
			imguploader.addEventListener(MouseEvent.CLICK, DoClick);
			addEventListener(MouseEvent.RIGHT_CLICK, dodonothing);
		}			
		
		function dodonothing(e:MouseEvent){
		}
		
		private function createNode(xC:int,yC:int){
			var nde:Sprite = new Sprite();
			nde.graphics.beginFill(0xffffff,1);
			nde.graphics.drawCircle(0, 0, 10);
			nde.graphics.endFill();
			nde.filters = [glowFilter1];
			nde.x = xC;
			nde.y = yC ;
			nde.addEventListener(MouseEvent.MOUSE_OVER, RemoveNode);
			nde.addEventListener(MouseEvent.CLICK, AddLink);
			nnodes++;
			nde.name = "n"+nnodes;
			nodesLayer.addChild(nde);
			NodesArray.push(nde);
			dataField.text = dtxt[0];
		}
		private function AddLink(e:MouseEvent):void{
						if (current_node == ""){
							current_node = e.target.name;
						}
						else{
							if (current_node != e.target.name){
								var nshape:Sprite = new Sprite();
								nshape.name = current_node+";"+e.target.name;
								nshape.graphics.lineStyle(3, 0x0032b8, 2);
								nshape.filters = [glowFilter2];
								nshape.graphics.moveTo(nodesLayer.getChildByName(current_node).x, nodesLayer.getChildByName(current_node).y);
								nshape.graphics.lineTo(nodesLayer.getChildByName(e.target.name).x, nodesLayer.getChildByName(e.target.name).y);
								nshape.addEventListener(MouseEvent.MOUSE_OVER, RemoveLink);
								
								linksLayer.addChild(nshape);
								LinksArray.push(nshape);
								
								current_node = "";
							}
						}
					
		}
		private function RemoveNode(e:MouseEvent):void{
				if (e.altKey&&mode==1) {
					current_node = "";
					for (i=0; i < NodesArray.length; i++){
						if (NodesArray[i].name == e.target.name){
							NodesArray.splice(i, 1);
						}               
					}
					colorNodesNormal();
					nodesLayer.removeChild(nodesLayer.getChildByName(e.target.name));
					dataField.text = dtxt[0];
				}
		}
		private function RemoveLink(e:MouseEvent):void{
			if (e.altKey&&mode==1) {
					current_node = "";
					for (i=0; i < LinksArray.length; i++){
						if (LinksArray[i].name == e.target.name){
							LinksArray.splice(i, 1);
						}               
					}
					colorNodesNormal();
					linksLayer.removeChild(linksLayer.getChildByName(e.target.name));
					dataField.text = dtxt[0];
				}
		}
		
		private function DoClick(e:MouseEvent):void{
			if(imguploader.imgd){
				if (!e.altKey) {
						switch (mode){
						case 0:
						break;
						case 1:
						createNode(mouseX,mouseY);
						break;
						case 2:
						createNode(mouseX,mouseY);
						break;
					}
				}
			}
		}
		public function addListenerToPannel(){
			pannel.nodesmode.addEventListener(MouseEvent.CLICK, DoNodesMode);
			
			pannel.networkchoose.addEventListener(MouseEvent.CLICK, DoNetwork);
			
			pannel.vertexmode.addEventListener(MouseEvent.CLICK, DoVertex);
			
			pannel.attackNet.addEventListener(MouseEvent.CLICK, DoAttackNet);
			pannel.defendNet.addEventListener(MouseEvent.CLICK, DoDefendNet);
			
			pannel.mapp.addEventListener(MouseEvent.CLICK, DoMapOP);
			pannel.mapm.addEventListener(MouseEvent.CLICK, DoMapOM);
			
			pannel.lowpannel.alpha = 0;
			pannel.lowpannel.leftver.addEventListener(MouseEvent.CLICK, DoColorVertexM);
			pannel.lowpannel.rightver.addEventListener(MouseEvent.CLICK, DoColorVertexP);
		}
		
		private function DoNodesMode(e:MouseEvent):void{
			current_node = "";
			mode = 1;
			colorNodesNormal();
			infoField.text = itxt[0]+itxt[1];
			dataField.text = dtxt[0];
		}
		private function colorit(){
			colornodes = [];
			colorlinks = [];
			for (i = 0; i < NodesArray.length; i++){
				colornodes.push([0x6fd3e1-i*5000,0]);
			}
			for (i = 0; i < LinksArray.length; i++){
				colorlinks.push([0x000000,0]);
			}
			for (i = 0; i < colornodes.length; i++){
				for (j = 0; j < colornodes.length; j++){
					if (networkarray[i][j] == 1){
						if (colornodes[j][1] == 0){
							colornodes[j][0] = colornodes[i][0];
							colornodes[j][1] = 1;
						}
						else{
							colornodes[i][0] = colornodes[j][0];
							colornodes[i][1] = 1;
						}
					}
				}
			}
			for (i = 0; i < NodesArray.length; i++){
				NodesArray[i].graphics.beginFill(colornodes[i][0],1);
				NodesArray[i].graphics.drawCircle(0, 0, 12);
				NodesArray[i].graphics.endFill();
			}
			
			/*
			for (i = 0; i < LinksArray.length; i++){
				LinksArray[i].graphics.lineStyle(3, colorlinks[i][0], 2);
				LinksArray[i].graphics.moveTo(getChildByName(LinksArray[i].name.split(";")[0]).x, getChildByName(LinksArray[i].name.split(";")[0]).y);
				LinksArray[i].graphics.lineTo(getChildByName(LinksArray[i].name.split(";")[1]).x, getChildByName(LinksArray[i].name.split(";")[1]).y);
			}
			/*
			for (i = 0; i < NodesArray.length; i++){
				for (j = 0; j < LinksArray.length; j++){
					if (NodesArray[i].name == LinksArray[j].name.split(";")[0] || NodesArray[i].name == LinksArray[j].name.split(";")[1]){
						NodesArray[i].graphics.beginFill(colorarray[j][0],0.7);
						NodesArray[i].graphics.drawCircle(0, 0, 12);
						NodesArray[i].graphics.endFill();
					}
				}
			}
			*/
		}
		
		private function colorNodesNormal(){
			for (i = 0; i < NodesArray.length; i++){
				NodesArray[i].filters = [glowFilter1];/*
				NodesArray[i].graphis.beginFill(0xffffff,1);
				NodesArray[i].graphics.drawCircle(0, 0, 12);
				NodesArray[i].graphics.endFill();*/
			}
		}
		private function colorNodesNormal2(){
			for (i = 0; i < NodesArray.length; i++){
				NodesArray[i].graphics.beginFill(0x36111c,1);
				NodesArray[i].graphics.drawCircle(0, 0, 12);
				NodesArray[i].graphics.endFill();
			}
		}
		private function colorVertex(l:int){
			colorNodesNormal();
			for (i = 0; i < vertexCC.vcovers[l].length; i++){
				NodesArray[vertexCC.vcovers[l][i]-1].filters = [glowFilter2,glowVertex,glowFilter2];/*
				NodesArray[vertexCC.vcovers[0][i]-1].graphics.beginFill(0x34dd00,1);
				NodesArray[vertexCC.vcovers[0][i]-1].graphics.drawCircle(0, 0, 12);
				NodesArray[vertexCC.vcovers[0][i]-1].graphics.endFill();*/
			}
		}
		
		private function DoNetwork(e:MouseEvent):void{
			current_node = "";
			if (mode != 1){
				dataField.text = "Vous devez créer le réseau dabord";
				return;				
			}
			var i2:int;
			var j2:int;
			var cChange=0x00000F;
			networkarray = [];
			
			
			for (i=0; i < NodesArray.length; i++){
				var narray:Array = new Array();
				for (j=0; j < NodesArray.length; j++){
					narray.push(0);
				}
				networkarray.push(narray);
			}
			
			
			for (i = 0; i < LinksArray.length; i++){
				for (i2=0; i2 < NodesArray.length; i2++){
					if (LinksArray[i].name.split(";")[0]==NodesArray[i2].name){
						for (j2=0; j2 < NodesArray.length; j2++){
							if (LinksArray[i].name.split(";")[1] == NodesArray[j2].name){
								networkarray[i2][j2] = 1;
								networkarray[j2][i2] = 1;
							}
						}
					}
				}
				
			}
			
			
			traceMatrice(networkarray);
			//colorit();
			infoField.text = itxt[0]+itxt[1];
			dataField.text = dtxt[1];
			
		}
		private function traceMatrice(matri:Array){
			var sto:String = new String();			
			trace("-------------------------------------");
			for (i=0; i < matri.length; i++){
				for (j=0; j < matri[i].length; j++){
					sto = sto + matri[i][j] + " ";
				}
				trace(sto);
				sto = "";
			}
			trace("-------------------------------------");
		}
		private function DoVertex(e:MouseEvent):void{
			current_node = "";
			if (mode != 1){
				dataField.text = "Vous devez créer le réseau dabord !";
				return;				
			}
				colorNodesNormal();
				vertexCC.graph = networkarray;
				vertexCC.n = networkarray.length;
				vertexCC.findVertex(1);
				kcolor = 0;
				colorVertex(0);
				infoField.text = itxt[0]+itxt[1];
				dataField.text = dtxt[2] + vertexCC.vcovers.length;
				mode = 11;
				if (vertexCC.vcovers.length > 1){
					pannel.lowpannel.alpha = 1;
					vertexNumField.text = "1/" + vertexCC.vcovers.length;
				}
				else pannel.lowpannel.alpha = 0;
				vertexCC.ocovers = vertexCC.vcovers;
		}
		private function DoAttackNet(e:MouseEvent):void{
			current_node = "";
			var i1:int;
			var j1:int;
			var k:int;
			var times:int;
			var bestpts:int;
			var killednodes:int;
			var killpts:Array = new Array();
			if (mode != 11 && mode != 3 && mode != 4){
				dataField.text = "Vous devez lancer le Vertex Cover dabord !";
				return;				
			}
			
			attackPlans = [];
			attackScenarios = [];
				mode = 3;
				
					for (k = 0; k < vertexCC.vcovers.length; k++ ){
						attackPlans.push(networkarray);
					}
					for (k = 0; k < vertexCC.vcovers.length; k++ ){
						attackScenarios.push(vertexCC.vcovers[k]);
					}
					
					for (k = 0; k < attackScenarios.length; k++ ){
						while (killednodes < 10){
							for (i1 = 0; i1 < attackScenarios[k].length; i1++ ){
								if (attackScenarios[k][i1] != 0 && Math.random() <= (1 / attackScenarios[k].length)){
									killednodes++;
									for (var k1:int = 0; k1 < networkarray.length;k1++) attackPlans[k][attackScenarios[k][i1] - 1][k1] = 0;
									for (var k1:int = 0; k1 < networkarray.length;k1++) attackPlans[k][k1][attackScenarios[k][i1] - 1] = 0;	
									attackScenarios[k][i1] = 0;
								}
								if (killednodes == 10) break;
							}
						}killednodes = 0;
					}
					
					times = attackScenarios.length;
					attackScenarios = [];
					killpts;
					for (k = 0; k < times; k++ ){
						vertexCC.graph = attackPlans[k];
						vertexCC.n = attackPlans[k].length;
						vertexCC.findVertex(1);
						attackScenarios.push(vertexCC.vcovers);
					}
					if ((attackScenarios||"").length>0) {
						 for (k = 0; k < LinksArray.length; k++){
							LinksArray[k].graphics.clear();
							LinksArray[k].filters = [];
							LinksArray[k].graphics.lineStyle(1, 0xffffff, 2);
							LinksArray[k].graphics.moveTo(nodesLayer.getChildByName(LinksArray[k].name.split(";")[0]).x, nodesLayer.getChildByName(LinksArray[k].name.split(";")[0]).y);
							LinksArray[k].graphics.lineTo(nodesLayer.getChildByName(LinksArray[k].name.split(";")[1]).x, nodesLayer.getChildByName(LinksArray[k].name.split(";")[1]).y);
							
							
						 }
						 colorNodesNormal2();
						return ;
						
					}

					for (var l1:int = 0; l1 < attackScenarios.length; l1++ ){
						killpts.push(0);
					}
					for (var l1:int = 0; l1 < attackScenarios.length; l1++ ){
						for (k = 0; k < attackScenarios[l1].length;k++ ) killpts[l1]=killpts[l1]-attackScenarios[l1].length*50;
					}
					bestpts = killpts[0];
					
					for (k= 0; k < killpts.length; k++ ){
						if (bestpts > killpts[k].length) bestpts = killpts[k].length;
					}
					
					for (var l1:int = 0; l1 < killpts.length; l1++ ){
						if (bestpts == killpts[l1]) {
							networkarray = attackPlans[l1];							
							break;
						}
					}
					for (k = 0; k < LinksArray.length; k++){
						for (var i2:int=0; i2 < NodesArray.length; i2++){
							if (LinksArray[k].name.split(";")[0]==NodesArray[i2].name){
								for (var j2:int=0; j2 < NodesArray.length; j2++){
									if (LinksArray[k].name.split(";")[1] == NodesArray[j2].name){
										if (networkarray[i2][j2] == 0 || networkarray[j2][i2] == 0){
											LinksArray[k].graphics.clear();
											LinksArray[k].filters = [];
											LinksArray[k].graphics.lineStyle(1, 0x000000, 2);
											LinksArray[k].graphics.moveTo(nodesLayer.getChildByName(LinksArray[k].name.split(";")[0]).x, nodesLayer.getChildByName(LinksArray[k].name.split(";")[0]).y);
											LinksArray[k].graphics.lineTo(nodesLayer.getChildByName(LinksArray[k].name.split(";")[1]).x, nodesLayer.getChildByName(LinksArray[k].name.split(";")[1]).y);
										}
									}
								}
							}
						}
						
					}
					
					
				infoField.text = itxt[0]+itxt[2];
				dataField.text = dtxt[3];
		}
		
		private function DoDefendNet(e:MouseEvent):void{
			current_node = "";
			if (mode != 11 && mode != 3 && mode != 4){
				dataField.text = "Vous devez lancer le Vertex Cover dabord !";
				return;				
			}
				mode = 4;
				trace(mode);
				infoField.text = itxt[0]+itxt[3];
				dataField.text = dtxt[4];
		}
		
		private function DoMapOP(e:MouseEvent):void{
			if (imguploader.alpha <= 1){
				imguploader.alpha = imguploader.alpha + 0.20;
			}
		}
		private function DoMapOM(e:MouseEvent):void{
			if (imguploader.alpha >= 0){
				imguploader.alpha = imguploader.alpha - 0.20;
				
			}
		}
		private function DoColorVertexM(e:MouseEvent):void{
			if (kcolor > 0){
				kcolor--;
			}
			else kcolor = vertexCC.vcovers.length-1;
			colorVertex(kcolor);
			vertexNumField.text = (kcolor+1) + "/" + vertexCC.vcovers.length;			
		}
		private function DoColorVertexP(e:MouseEvent):void{
			if (kcolor < vertexCC.vcovers.length - 1){
				kcolor++;
			}
			else kcolor = 0;
			colorVertex(kcolor);
			vertexNumField.text = (kcolor+1) + "/" + vertexCC.vcovers.length;
		}
	}
	
}
