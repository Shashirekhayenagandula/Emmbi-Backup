public class OTPLangugaeFetch {
    public static string getlablelang(string lang){
        String fetchlang;
        if(lang!=null && lang=='Kannada'){
            fetchlang=System.Label.Kannada;
        }
        else if(lang!=null && lang=='Marathi'){
            fetchlang=System.Label.Marathi;            
        }
        else{
            fetchlang=System.Label.Hindi;
        }
        return fetchlang;
    }
    
}