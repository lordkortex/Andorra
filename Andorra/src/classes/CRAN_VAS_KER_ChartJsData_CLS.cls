global virtual class CRAN_VAS_KER_ChartJsData_CLS {
   
    global ChartData 	data;
    global ChartOptions options;
    global Decimal		width;
    global Decimal		height;
    global String		chartType;
    
    global CRAN_VAS_KER_ChartJsData_CLS() {
        data 	= new ChartData();
        options = new ChartOptions();
        width	= 300;
        height  = 300;
    }
    
    global class ChartOptions {
        
        global ChartOptionTitle title;
        global Boolean 			responsive;
        
    }
    
    global class ChartOptionTitle {
        global Boolean display;
        global String position;
        global String text;
    }
    
    global class chartjsDataset {
        global string label;
        global list<string> backgroundColor;
        global list<string> hoverBackgroundColor;
        global list<integer> data;
    }
    
    global class ChartData {
        global list<string> labels;
        global list<chartjsDataset> datasets;
    }
    
    global List<List<Integer>> getRandomColor(Integer size, Boolean thin) {
        
        Decimal r = 0;
        Decimal g = 0;
        Decimal b = 0;         
        Integer thin_plus = thin ? 1 : 0;
        
        List<List<Integer>> colors = new List<List<Integer>>();
        
        Integer counter = 0;
        Integer max = 0;
        
        for ( Integer i=0 ; ; i++ ) {
            if ( Math.pow(i,3) >= size ) {
                max = i - 1 + thin_plus;
                break;
            }
        }
        
        Decimal plus = 255 / max;
        
        for (Integer i = thin_plus; i <= max; i++) {
            
            r = plus * i;
            g = 0;
            b = 0;
            
            for ( Integer j = thin_plus; j <= max; j++) {
                g = plus * j;
                b = 0;
                
                for ( Integer k = thin_plus; k <= max ;k++) {
                    b = plus * k;
                    List<Integer> rgbas = new List<Integer>();
                    rgbas.add(Math.round(r));
                    rgbas.add(Math.round(g));
                    rgbas.add(Math.round(b));
                    colors.add(rgbas);
                    if ( colors.size() >= size )
                        return colors;
                }
                
                if ( colors.size() >= size )
                    return colors;
            }
            
            if ( colors.size() >= size )
                return colors;
        }
        
        return null;
    }
    
}