package com.medlyves.simple_kiosk_software;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.content.Context;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbDeviceConnection;
import android.hardware.usb.UsbEndpoint;
import android.hardware.usb.UsbInterface;
import android.hardware.usb.UsbManager;
import android.hardware.usb.UsbRequest;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.List;

public class XKPrinterHelper
{
    public String devPath = "";

    private UsbManager usbManager;
    private UsbDevice printerDevice;
    private UsbDeviceConnection connection;
    private UsbInterface usbInterface;
    private UsbEndpoint endpoint;

    public XKPrinterHelper(Context context) {
        usbManager = (UsbManager) context.getSystemService(Context.USB_SERVICE);
    }

    public boolean setupPrinter() {
        HashMap<String, UsbDevice> deviceList = usbManager.getDeviceList();
        for (UsbDevice device : deviceList.values()) {
            if (device.getDeviceName().equals(devPath)) {
                printerDevice = device;
                break;
            }
        }

        if (printerDevice == null) {
            return false;
        }

        connection = usbManager.openDevice(printerDevice);
        usbInterface = printerDevice.getInterface(0);
        endpoint = usbInterface.getEndpoint(0);
        connection.claimInterface(usbInterface, true);

        return true;
    }

    public boolean printData(byte[] data) {
        if (connection == null) {
            if (!setupPrinter()) {
                return false;
            }
        }

        byte[] cmd;
        cmd = SetClean();
        write(cmd, cmd.length);
        cmd = printBitmap(data);
        write(cmd, cmd.length);
        cmd = PrintFeedline(5);
        write(cmd, cmd.length);
        cmd = PrintCutpaper(1);
        write(cmd, cmd.length);
        // UsbRequest request = new UsbRequest();
        // request.initialize(connection, endpoint);
        // byte[] printerCmd = printBitmap(data);
        // byte[] printerCmd = SetClean();
        // connection.bulkTransfer()
        // ByteBuffer buffer = ByteBuffer.wrap(printerCmd);
        // request.queue(buffer, printerCmd.length);
        // return connection.requestWait() == request;
        return true;
    }

    public byte[] convertIntegersToBytes(List<Integer> integers) {
        byte[] bytes = new byte[integers.size()];
        for (int i = 0; i < integers.size(); i++) {
            bytes[i] = integers.get(i).byteValue();
        }
        return bytes;
    }

    public void closeConnection() {
        if (connection != null && printerDevice != null) {
            connection.releaseInterface(usbInterface);
            connection.close();
        }
    }

    public byte[] printBitmap(byte[] data) {
        Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);
        if (bitmap == null) {
            return null;
        }
        // if (!strPath.substring(strPath.toLowerCase().indexOf(".") + 1).equals("bmp")) {
        //     Bitmap bitmap2 = UtilsTools.convertToBlackWhite(bitmap);
        //     int width = bitmap2.getWidth();
        //     int heigh = bitmap2.getHeight();
        //     int iDataLen = width * heigh;
        //     int[] pixels = new int[iDataLen];
        //     bitmap2.getPixels(pixels, 0, width, 0, 0, width, heigh);
        //     byte[] bytes = PrintDiskImagefile(pixels, width, heigh);
        //     return bytes;
        // }
        int width2 = bitmap.getWidth();
        int heigh2 = bitmap.getHeight();
        int iDataLen2 = width2 * heigh2;
        int[] pixels2 = new int[iDataLen2];
        bitmap.getPixels(pixels2, 0, width2, 0, 0, width2, heigh2);
        byte[] printCmd = getPrintCmdFromImage(pixels2, width2, heigh2);
        return printCmd;
    }

    public byte[] getPrintCmdFromImage(int[] pixels, int iWidth, int iHeight) {
        int iBw = iWidth / 8;
        int iMod = iWidth % 8;
        if (iMod > 0) {
            iBw++;
        }
        int iDataLen = iBw * iHeight;
        byte[] bCmd = new byte[iDataLen + 8];
        int iIndex = 0 + 1;
        bCmd[0] = 29;
        int iIndex2 = iIndex + 1;
        bCmd[iIndex] = 118;
        int iIndex3 = iIndex2 + 1;
        bCmd[iIndex2] = 48;
        int iIndex4 = iIndex3 + 1;
        bCmd[iIndex3] = 0;
        int iIndex5 = iIndex4 + 1;
        bCmd[iIndex4] = (byte) iBw;
        int iIndex6 = iIndex5 + 1;
        bCmd[iIndex5] = (byte) (iBw >> 8);
        int iIndex7 = iIndex6 + 1;
        bCmd[iIndex6] = (byte) iHeight;
        int iIndex8 = iIndex7 + 1;
        bCmd[iIndex7] = (byte) (iHeight >> 8);
        int iW = 0;
        int iValue3 = 0;
        int iValue4 = 0;
        int iRow = 0;
        while (iRow < iHeight) {
            int iCol = 0;
            while (iCol < iBw - 1) {
                int iValue2 = 0;
                int iW2 = iW + 1;
                int iValue1 = pixels[iW];
                if (iValue1 < -1) {
                    iValue2 = 0 + 128;
                }
                int iW3 = iW2 + 1;
                int iValue12 = pixels[iW2];
                if (iValue12 < -1) {
                    iValue2 += 64;
                }
                int iW4 = iW3 + 1;
                int iValue13 = pixels[iW3];
                if (iValue13 < -1) {
                    iValue2 += 32;
                }
                int iW5 = iW4 + 1;
                int iValue14 = pixels[iW4];
                if (iValue14 < -1) {
                    iValue2 += 16;
                }
                int iW6 = iW5 + 1;
                int iValue15 = pixels[iW5];
                if (iValue15 < -1) {
                    iValue2 += 8;
                }
                int iW7 = iW6 + 1;
                int iValue16 = pixels[iW6];
                if (iValue16 < -1) {
                    iValue2 += 4;
                }
                int iW8 = iW7 + 1;
                int iValue17 = pixels[iW7];
                if (iValue17 < -1) {
                    iValue2 += 2;
                }
                iW = iW8 + 1;
                int iValue18 = pixels[iW8];
                if (iValue18 < -1) {
                    iValue2++;
                }
                if (iValue3 < -1) {
                    iValue4 += 16;
                }
                bCmd[iIndex8] = (byte) iValue2;
                iCol++;
                iIndex8++;
            }
            int iValue22 = 0;
            if (iValue4 > 0) {
                iValue3 = 1;
            }
            if (iMod == 0) {
                int iCol2 = 8;
                while (iCol2 > iMod) {
                    int iW9 = iW + 1;
                    int iValue19 = pixels[iW];
                    if (iValue19 < -1) {
                        iValue22 += 1 << iCol2;
                    }
                    iCol2--;
                    iW = iW9;
                }
            } else {
                int iCol3 = 0;
                while (iCol3 < iMod) {
                    int iW10 = iW + 1;
                    int iValue110 = pixels[iW];
                    if (iValue110 < -1) {
                        iValue22 += 1 << (8 - iCol3);
                    }
                    iCol3++;
                    iW = iW10;
                }
            }
            bCmd[iIndex8] = (byte) iValue22;
            iRow++;
            iIndex8++;
        }
        return bCmd;
    }

    // public Bitmap convertToBlackWhite(Bitmap bmp) {
    //     int e;
    //     System.out.println(bmp.getConfig());
    //     int width = bmp.getWidth();
    //     int height = bmp.getHeight();
    //     if (width > 640) {
    //         width = WinError.ERROR_MULTIPLE_FAULT_VIOLATION;
    //     }
    //     int[] pixels = new int[width * height];
    //     bmp.getPixels(pixels, 0, width, 0, 0, width, height);
    //     int[] gray = new int[height * width];
    //     for (int i = 0; i < height; i++) {
    //         for (int j = 0; j < width; j++) {
    //             try {
    //                 int grey = pixels[(width * i) + j];
    //                 int red = (16711680 & grey) >> 16;
    //                 gray[(width * i) + j] = red;
    //             } catch (Exception e2) {
    //                 Log.e("ContentValues", "PrintBmp:" + e2.getMessage());
    //             }
    //         }
    //     }
    //     for (int i2 = 0; i2 < height; i2++) {
    //         for (int j2 = 0; j2 < width; j2++) {
    //             int g = gray[(width * i2) + j2];
    //             if (g >= 128) {
    //                 pixels[(width * i2) + j2] = -1;
    //                 e = g - 255;
    //             } else {
    //                 int e3 = width * i2;
    //                 pixels[e3 + j2] = -16777216;
    //                 e = g + 0;
    //             }
    //             if (j2 < width - 1 && i2 < height - 1) {
    //                 int i3 = (width * i2) + j2 + 1;
    //                 gray[i3] = gray[i3] + ((e * 3) / 8);
    //                 int i4 = ((i2 + 1) * width) + j2;
    //                 gray[i4] = gray[i4] + ((e * 3) / 8);
    //                 int i5 = ((i2 + 1) * width) + j2 + 1;
    //                 gray[i5] = gray[i5] + (e / 4);
    //             } else if (j2 == width - 1 && i2 < height - 1) {
    //                 int i6 = ((i2 + 1) * width) + j2;
    //                 gray[i6] = gray[i6] + ((e * 3) / 8);
    //             } else if (j2 < width - 1 && i2 == height - 1) {
    //                 int i7 = (width * i2) + j2 + 1;
    //                 gray[i7] = gray[i7] + (e / 4);
    //             }
    //         }
    //     }
    //     Bitmap newBmp = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565);
    //     newBmp.setPixels(pixels, 0, width, 0, 0, width, height);
    //     Bitmap resizeBmp = ThumbnailUtils.extractThumbnail(newBmp, width, height);
    //     return resizeBmp;
    // }

    public static byte[] SetClean() {
        byte[] bCmd = new byte[2];
        int iIndex = 0 + 1;
        bCmd[0] = 27;
        int i = iIndex + 1;
        bCmd[iIndex] = 64;
        return bCmd;
    }


    public static byte[] PrintFeedline(int iLine) {
        byte[] bCmd = new byte[3];
        int iIndex = 0 + 1;
        bCmd[0] = 27;
        int iIndex2 = iIndex + 1;
        bCmd[iIndex] = 100;
        int i = iIndex2 + 1;
        bCmd[iIndex2] = (byte) iLine;
        return bCmd;
    }

    public static byte[] PrintCutpaper(int iMode) {
        int iIndex;
        byte[] bCmd = new byte[3];
        if (iMode != 1) {
            int iIndex2 = 0 + 1;
            bCmd[0] = 27;
            iIndex = iIndex2 + 1;
            bCmd[iIndex2] = 105;
        } else {
            int iIndex3 = 0 + 1;
            bCmd[0] = 27;
            iIndex = iIndex3 + 1;
            bCmd[iIndex3] = 109;
        }
        int i = iIndex + 1;
        bCmd[iIndex] = (byte) iMode;
        return bCmd;
    }

    public int write(byte[] buf, int length) {
        int i = length;
        int offset = 0;
        try {
            byte[] write_buf = new byte[4096];
            while (offset < i) {
                int write_size = 4096;
                if (offset + 4096 > i) {
                    write_size = i - offset;
                }
                try {
                    System.arraycopy(buf, offset, write_buf, 0, write_size);
                    int actual_length = connection.bulkTransfer(endpoint, write_buf, write_size, 3000);
                    if (actual_length < 0) {
                        // unlock();
                        return -1;
                    }
                    offset += actual_length;
                } catch (Exception e) {
                }
            }
            byte[] bArr = buf;
        } catch (Exception e2) {
            byte[] bArr2 = buf;
        }
        return offset;
    }
}
