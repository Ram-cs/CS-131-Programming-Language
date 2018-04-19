/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author RamYadav
 */
import java.util.concurrent.locks.ReentrantLock;
public class BetterSafe implements State {
    private ReentrantLock reenLock;
    private byte value_array[];
    private byte maxval;
    
    BetterSafe(byte[] b) {
        maxval = 127;
        value_array = b;
        reenLock = new ReentrantLock();
    }
    
    BetterSafe(byte[] b, byte maxVal) {
        maxval = maxVal;
        value_array = b;
        reenLock = new ReentrantLock();
    }

    @Override
    public int size() {
        return value_array.length;
    }

    @Override
    public byte[] current() {
        return value_array;
    }

    @Override
    public boolean swap(int i, int j) {
        reenLock.lock();
        if (value_array[i] <= 0 || value_array[j] >= maxval) {
            reenLock.unlock();
            return false;
        } else {
            value_array[i]--;
            value_array[j]++;
            reenLock.unlock();
          return true;  
        }
    }

}
