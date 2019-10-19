package iceberg.gunsnhoney.flutter_bone;

import android.os.Bundle;

import iceberg.gunsnhoney.flutter_bone.cypher.CypherUtil;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;



public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "iceberg.gunsnhoney.flutter_bone/cypher";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                switch(call.method) {
                    case "encryptMsg":
                        final byte[] salt = call.argument("salt");
                        final byte[] pepper = call.argument("pepper");
                        final String password = call.argument("password");
                        final String clearMessage = call.argument("clearMessage");
                        byte [] encryptedMessageByteForm = CypherUtil.encryptMsg(password, clearMessage, salt, pepper);
                        result.success(encryptedMessageByteForm);
                        break;
                    case "decryptMsg":
                        final byte[] encryptedMessage = call.argument("encryptedMessage");
                        final String password4Decrypt = call.argument("password");
                        final byte[] salt4Encrypt = call.argument("salt");
                        final byte[] pepper4Encrypt = call.argument("pepper");
                        String decryptedMessage = CypherUtil.decryptMsg(encryptedMessage, password4Decrypt,salt4Encrypt, pepper4Encrypt);
                        result.success(decryptedMessage);
                        break;
                    case "generateSalt":
                        byte [] genSalt = CypherUtil.generateSalt();
                        result.success(genSalt);
                        break;
                    case "generateIV":
                        byte [] iv = CypherUtil.generateInitializationVector();
                        result.success(iv);
                        break;
                }
              }
            }
    );
  }

}
