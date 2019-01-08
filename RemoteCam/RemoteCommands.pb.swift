// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: RemoteCommands.proto
//
// For information on using the generated types, please see the documenation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that your are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct RemoteShutterEnvelope {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var contentType: RemoteShutterEnvelope.ContentType {
    get {return _storage._contentType}
    set {_uniqueStorage()._contentType = newValue}
  }

  var version: String {
    get {return _storage._version}
    set {_uniqueStorage()._version = newValue}
  }

  var takePic: TakePic {
    get {return _storage._takePic ?? TakePic()}
    set {_uniqueStorage()._takePic = newValue}
  }
  /// Returns true if `takePic` has been explicitly set.
  var hasTakePic: Bool {return _storage._takePic != nil}
  /// Clears the value of `takePic`. Subsequent reads from it will return its default value.
  mutating func clearTakePic() {_uniqueStorage()._takePic = nil}

  var takePicAck: TakePicAck {
    get {return _storage._takePicAck ?? TakePicAck()}
    set {_uniqueStorage()._takePicAck = newValue}
  }
  /// Returns true if `takePicAck` has been explicitly set.
  var hasTakePicAck: Bool {return _storage._takePicAck != nil}
  /// Clears the value of `takePicAck`. Subsequent reads from it will return its default value.
  mutating func clearTakePicAck() {_uniqueStorage()._takePicAck = nil}

  var takePicResp: TakePicResp {
    get {return _storage._takePicResp ?? TakePicResp()}
    set {_uniqueStorage()._takePicResp = newValue}
  }
  /// Returns true if `takePicResp` has been explicitly set.
  var hasTakePicResp: Bool {return _storage._takePicResp != nil}
  /// Clears the value of `takePicResp`. Subsequent reads from it will return its default value.
  mutating func clearTakePicResp() {_uniqueStorage()._takePicResp = nil}

  var toggleFlash: ToggleFlash {
    get {return _storage._toggleFlash ?? ToggleFlash()}
    set {_uniqueStorage()._toggleFlash = newValue}
  }
  /// Returns true if `toggleFlash` has been explicitly set.
  var hasToggleFlash: Bool {return _storage._toggleFlash != nil}
  /// Clears the value of `toggleFlash`. Subsequent reads from it will return its default value.
  mutating func clearToggleFlash() {_uniqueStorage()._toggleFlash = nil}

  var toggleFlashResp: ToggleFlashResp {
    get {return _storage._toggleFlashResp ?? ToggleFlashResp()}
    set {_uniqueStorage()._toggleFlashResp = newValue}
  }
  /// Returns true if `toggleFlashResp` has been explicitly set.
  var hasToggleFlashResp: Bool {return _storage._toggleFlashResp != nil}
  /// Clears the value of `toggleFlashResp`. Subsequent reads from it will return its default value.
  mutating func clearToggleFlashResp() {_uniqueStorage()._toggleFlashResp = nil}

  var toggleCamera: ToggleCamera {
    get {return _storage._toggleCamera ?? ToggleCamera()}
    set {_uniqueStorage()._toggleCamera = newValue}
  }
  /// Returns true if `toggleCamera` has been explicitly set.
  var hasToggleCamera: Bool {return _storage._toggleCamera != nil}
  /// Clears the value of `toggleCamera`. Subsequent reads from it will return its default value.
  mutating func clearToggleCamera() {_uniqueStorage()._toggleCamera = nil}

  var toggleCameraResp: ToggleCameraResp {
    get {return _storage._toggleCameraResp ?? ToggleCameraResp()}
    set {_uniqueStorage()._toggleCameraResp = newValue}
  }
  /// Returns true if `toggleCameraResp` has been explicitly set.
  var hasToggleCameraResp: Bool {return _storage._toggleCameraResp != nil}
  /// Clears the value of `toggleCameraResp`. Subsequent reads from it will return its default value.
  mutating func clearToggleCameraResp() {_uniqueStorage()._toggleCameraResp = nil}

  var sendFrame: SendFrame {
    get {return _storage._sendFrame ?? SendFrame()}
    set {_uniqueStorage()._sendFrame = newValue}
  }
  /// Returns true if `sendFrame` has been explicitly set.
  var hasSendFrame: Bool {return _storage._sendFrame != nil}
  /// Clears the value of `sendFrame`. Subsequent reads from it will return its default value.
  mutating func clearSendFrame() {_uniqueStorage()._sendFrame = nil}

  var peerBecameCamera: PeerBecameCamera {
    get {return _storage._peerBecameCamera ?? PeerBecameCamera()}
    set {_uniqueStorage()._peerBecameCamera = newValue}
  }
  /// Returns true if `peerBecameCamera` has been explicitly set.
  var hasPeerBecameCamera: Bool {return _storage._peerBecameCamera != nil}
  /// Clears the value of `peerBecameCamera`. Subsequent reads from it will return its default value.
  mutating func clearPeerBecameCamera() {_uniqueStorage()._peerBecameCamera = nil}

  var peerBecameMonitor: PeerBecameMonitor {
    get {return _storage._peerBecameMonitor ?? PeerBecameMonitor()}
    set {_uniqueStorage()._peerBecameMonitor = newValue}
  }
  /// Returns true if `peerBecameMonitor` has been explicitly set.
  var hasPeerBecameMonitor: Bool {return _storage._peerBecameMonitor != nil}
  /// Clears the value of `peerBecameMonitor`. Subsequent reads from it will return its default value.
  mutating func clearPeerBecameMonitor() {_uniqueStorage()._peerBecameMonitor = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum ContentType: SwiftProtobuf.Enum {
    typealias RawValue = Int
    case unknown // = 0
    case takePic // = 1
    case takePicAck // = 2
    case takePicResp // = 3
    case toggleFlash // = 4
    case toggleFlashResp // = 5
    case toggleCamera // = 6
    case toggleCameraResp // = 7
    case sendFrame // = 8
    case peerBecameCamera // = 9
    case peerBecameMonitor // = 10
    case UNRECOGNIZED(Int)

    init() {
      self = .unknown
    }

    init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .unknown
      case 1: self = .takePic
      case 2: self = .takePicAck
      case 3: self = .takePicResp
      case 4: self = .toggleFlash
      case 5: self = .toggleFlashResp
      case 6: self = .toggleCamera
      case 7: self = .toggleCameraResp
      case 8: self = .sendFrame
      case 9: self = .peerBecameCamera
      case 10: self = .peerBecameMonitor
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    var rawValue: Int {
      switch self {
      case .unknown: return 0
      case .takePic: return 1
      case .takePicAck: return 2
      case .takePicResp: return 3
      case .toggleFlash: return 4
      case .toggleFlashResp: return 5
      case .toggleCamera: return 6
      case .toggleCameraResp: return 7
      case .sendFrame: return 8
      case .peerBecameCamera: return 9
      case .peerBecameMonitor: return 10
      case .UNRECOGNIZED(let i): return i
      }
    }

  }

  init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

#if swift(>=4.2)

extension RemoteShutterEnvelope.ContentType: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static var allCases: [RemoteShutterEnvelope.ContentType] = [
    .unknown,
    .takePic,
    .takePicAck,
    .takePicResp,
    .toggleFlash,
    .toggleFlashResp,
    .toggleCamera,
    .toggleCameraResp,
    .sendFrame,
    .peerBecameCamera,
    .peerBecameMonitor,
  ]
}

#endif  // swift(>=4.2)

struct TakePic {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct TakePicAck {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct TakePicResp {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct ToggleFlash {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct ToggleFlashResp {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct ToggleCamera {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct ToggleCameraResp {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct SendFrame {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct PeerBecameCamera {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct PeerBecameMonitor {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension RemoteShutterEnvelope: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "RemoteShutterEnvelope"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "content_type"),
    2: .same(proto: "version"),
    3: .standard(proto: "take_pic"),
    4: .standard(proto: "take_pic_ack"),
    5: .standard(proto: "take_pic_resp"),
    6: .standard(proto: "toggle_flash"),
    7: .standard(proto: "toggle_flash_resp"),
    8: .standard(proto: "toggle_camera"),
    9: .standard(proto: "toggle_camera_resp"),
    10: .standard(proto: "send_frame"),
    11: .standard(proto: "peer_became_camera"),
    12: .standard(proto: "peer_became_monitor"),
  ]

  fileprivate class _StorageClass {
    var _contentType: RemoteShutterEnvelope.ContentType = .unknown
    var _version: String = String()
    var _takePic: TakePic? = nil
    var _takePicAck: TakePicAck? = nil
    var _takePicResp: TakePicResp? = nil
    var _toggleFlash: ToggleFlash? = nil
    var _toggleFlashResp: ToggleFlashResp? = nil
    var _toggleCamera: ToggleCamera? = nil
    var _toggleCameraResp: ToggleCameraResp? = nil
    var _sendFrame: SendFrame? = nil
    var _peerBecameCamera: PeerBecameCamera? = nil
    var _peerBecameMonitor: PeerBecameMonitor? = nil

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _contentType = source._contentType
      _version = source._version
      _takePic = source._takePic
      _takePicAck = source._takePicAck
      _takePicResp = source._takePicResp
      _toggleFlash = source._toggleFlash
      _toggleFlashResp = source._toggleFlashResp
      _toggleCamera = source._toggleCamera
      _toggleCameraResp = source._toggleCameraResp
      _sendFrame = source._sendFrame
      _peerBecameCamera = source._peerBecameCamera
      _peerBecameMonitor = source._peerBecameMonitor
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 1: try decoder.decodeSingularEnumField(value: &_storage._contentType)
        case 2: try decoder.decodeSingularStringField(value: &_storage._version)
        case 3: try decoder.decodeSingularMessageField(value: &_storage._takePic)
        case 4: try decoder.decodeSingularMessageField(value: &_storage._takePicAck)
        case 5: try decoder.decodeSingularMessageField(value: &_storage._takePicResp)
        case 6: try decoder.decodeSingularMessageField(value: &_storage._toggleFlash)
        case 7: try decoder.decodeSingularMessageField(value: &_storage._toggleFlashResp)
        case 8: try decoder.decodeSingularMessageField(value: &_storage._toggleCamera)
        case 9: try decoder.decodeSingularMessageField(value: &_storage._toggleCameraResp)
        case 10: try decoder.decodeSingularMessageField(value: &_storage._sendFrame)
        case 11: try decoder.decodeSingularMessageField(value: &_storage._peerBecameCamera)
        case 12: try decoder.decodeSingularMessageField(value: &_storage._peerBecameMonitor)
        default: break
        }
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if _storage._contentType != .unknown {
        try visitor.visitSingularEnumField(value: _storage._contentType, fieldNumber: 1)
      }
      if !_storage._version.isEmpty {
        try visitor.visitSingularStringField(value: _storage._version, fieldNumber: 2)
      }
      if let v = _storage._takePic {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
      }
      if let v = _storage._takePicAck {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
      }
      if let v = _storage._takePicResp {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
      }
      if let v = _storage._toggleFlash {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 6)
      }
      if let v = _storage._toggleFlashResp {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 7)
      }
      if let v = _storage._toggleCamera {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 8)
      }
      if let v = _storage._toggleCameraResp {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 9)
      }
      if let v = _storage._sendFrame {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 10)
      }
      if let v = _storage._peerBecameCamera {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 11)
      }
      if let v = _storage._peerBecameMonitor {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 12)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: RemoteShutterEnvelope, rhs: RemoteShutterEnvelope) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._contentType != rhs_storage._contentType {return false}
        if _storage._version != rhs_storage._version {return false}
        if _storage._takePic != rhs_storage._takePic {return false}
        if _storage._takePicAck != rhs_storage._takePicAck {return false}
        if _storage._takePicResp != rhs_storage._takePicResp {return false}
        if _storage._toggleFlash != rhs_storage._toggleFlash {return false}
        if _storage._toggleFlashResp != rhs_storage._toggleFlashResp {return false}
        if _storage._toggleCamera != rhs_storage._toggleCamera {return false}
        if _storage._toggleCameraResp != rhs_storage._toggleCameraResp {return false}
        if _storage._sendFrame != rhs_storage._sendFrame {return false}
        if _storage._peerBecameCamera != rhs_storage._peerBecameCamera {return false}
        if _storage._peerBecameMonitor != rhs_storage._peerBecameMonitor {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension RemoteShutterEnvelope.ContentType: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "UNKNOWN"),
    1: .same(proto: "TAKE_PIC"),
    2: .same(proto: "TAKE_PIC_ACK"),
    3: .same(proto: "TAKE_PIC_RESP"),
    4: .same(proto: "TOGGLE_FLASH"),
    5: .same(proto: "TOGGLE_FLASH_RESP"),
    6: .same(proto: "TOGGLE_CAMERA"),
    7: .same(proto: "TOGGLE_CAMERA_RESP"),
    8: .same(proto: "SEND_FRAME"),
    9: .same(proto: "PEER_BECAME_CAMERA"),
    10: .same(proto: "PEER_BECAME_MONITOR"),
  ]
}

extension TakePic: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "TakePic"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: TakePic, rhs: TakePic) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension TakePicAck: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "TakePicAck"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: TakePicAck, rhs: TakePicAck) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension TakePicResp: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "TakePicResp"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: TakePicResp, rhs: TakePicResp) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ToggleFlash: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "ToggleFlash"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: ToggleFlash, rhs: ToggleFlash) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ToggleFlashResp: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "ToggleFlashResp"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: ToggleFlashResp, rhs: ToggleFlashResp) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ToggleCamera: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "ToggleCamera"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: ToggleCamera, rhs: ToggleCamera) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ToggleCameraResp: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "ToggleCameraResp"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: ToggleCameraResp, rhs: ToggleCameraResp) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SendFrame: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "SendFrame"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SendFrame, rhs: SendFrame) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension PeerBecameCamera: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "PeerBecameCamera"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: PeerBecameCamera, rhs: PeerBecameCamera) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension PeerBecameMonitor: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "PeerBecameMonitor"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: PeerBecameMonitor, rhs: PeerBecameMonitor) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}