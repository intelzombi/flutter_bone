package iceberg.gunsnhoney.flutter_bone.cypher;

public class SaltAndPepper {
    private final String Salt;
    private final String iVector;

    public SaltAndPepper(String salt, String iVector) {
        Salt = salt;
        this.iVector = iVector;
    }

    public String getSalt() {
        return Salt;
    }

    public String getiVector() {
        return iVector;
    }
}
