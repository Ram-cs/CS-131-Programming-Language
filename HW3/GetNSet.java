/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author RamYadav
 */
import java.util.concurrent.atomic.AtomicIntegerArray;

public final class GetNSet implements State {
    private byte maxval;
    private static AtomicIntegerArray at;
       
    GetNSet(byte[] b) {
        maxval = 127;
        int[] intArray = new int[b.length];
        int i = 0;
        while (i < b.length) {
            intArray[i] = b[i];
            i++;
            
        }
            at = new AtomicIntegerArray(intArray);
    }
      
    GetNSet(byte[] b, byte maxVal) {
        maxval = maxVal;
        int[] intArray = new int[b.length];
        int i = 0;
        while (i < b.length) {
            intArray[i] = b[i];
            i++;
            
        }
            at = new AtomicIntegerArray(intArray);
    } 
      
    
    @Override
    public int size() {
        return at.length();
    }
      
    
    @Override
    public byte[] current() {
        byte return_atmArray[] = new byte[at.length()];
        int i = 0;
        while (i < return_atmArray.length) {
            return_atmArray[i] = (byte) at.get(i);
            i++;
        }
        return return_atmArray;
    }

    @Override
    public boolean swap(int i, int j) {
        if (at.get(i) <= 0 || at.get(j) >= maxval) {
            return false;
        }
        at.getAndDecrement(i);
        at.getAndIncrement(j);
        return true;
    }
}
