//
//  AKBitCrusherAudioUnit.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import AVFoundation

public class AKBitCrusherAudioUnit: AKAudioUnitBase {

    func setParameter(_ address: AKBitCrusherParameter, value: Double) {
        setParameterWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }

    func setParameterImmediately(_ address: AKBitCrusherParameter, value: Double) {
        setParameterImmediatelyWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }

    var bitDepth: Double = AKBitCrusher.defaultBitDepth {
        didSet { setParameter(.bitDepth, value: bitDepth) }
    }

    var sampleRate: Double = AKBitCrusher.defaultSampleRate {
        didSet { setParameter(.sampleRate, value: sampleRate) }
    }

    var rampTime: Double = 0.0 {
        didSet { setParameter(.rampTime, value: rampTime) }
    }

    public override func initDSP(withSampleRate sampleRate: Double,
                                 channelCount count: AVAudioChannelCount) -> UnsafeMutableRawPointer! {
        return createBitCrusherDSP(Int32(count), sampleRate)
    }

    public override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        let flags: AudioUnitParameterOptions = [.flag_IsReadable, .flag_IsWritable, .flag_CanRamp]

        let bitDepth = AUParameterTree.createParameter(
            withIdentifier: "bitDepth",
            name: "Bit Depth",
            address: AUParameterAddress(0),
            min: Float(AKBitCrusher.bitDepthRange.lowerBound),
            max: Float(AKBitCrusher.bitDepthRange.upperBound),
            unit: .generic,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )
        let sampleRate = AUParameterTree.createParameter(
            withIdentifier: "sampleRate",
            name: "Sample Rate (Hz)",
            address: AUParameterAddress(1),
            min: Float(AKBitCrusher.sampleRateRange.lowerBound),
            max: Float(AKBitCrusher.sampleRateRange.upperBound),
            unit: .hertz,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )

        setParameterTree(AUParameterTree.createTree(withChildren: [bitDepth, sampleRate]))
        bitDepth.value = Float(AKBitCrusher.defaultBitDepth)
        sampleRate.value = Float(AKBitCrusher.defaultSampleRate)
    }

    public override var canProcessInPlace: Bool { get { return true; }}

}
