import 'package:hooks/hooks.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';

void main(List<String> args) async {
  // The hooks 1.0.1 way
  await build(args, (input, output) async {
    final builder = RustBuilder(
      assetName: 'my_flutter_app',
      cratePath: 'native_ulid',
    );
    
    // This handles cross-compilation and asset registration in one go
    await builder.run(input: input, output: output);
  });
}