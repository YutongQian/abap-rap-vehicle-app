extend view entity Z_R_10VEHTYPE with {
    @Semantics.quantity.unitOfMeasure: 'ZZLiftMaxUnitZCA'
    Vehicletype.zzlift_capmaxzca as ZZLiftCapmaxZCA,
    @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI10_MassunitVH', 
                                          element: 'UnitOfMeasure' } } ]
    Vehicletype.zzlift_maxunitzca as ZZLiftMaxUnitZCA,
    @Semantics.quantity.unitOfMeasure: 'ZZLiftMinUnitZCA'
    Vehicletype.zzlift_capminzca as ZZLiftCapminZCA,
    @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI10_MassunitVH', 
                                          element: 'UnitOfMeasure' } } ]
    Vehicletype.zzlift_minunitzca as ZZLiftMinUnitZCA,    
    @Semantics.quantity.unitOfMeasure: 'ZZHeightUnitZCA'
    Vehicletype.zzmax_heightzca as ZZMaxHeightZCA,
    @Consumption.valueHelpDefinition: [ { entity: { name: 'Z10_LengthunitVH', 
                                          element: 'UnitOfMeasure' } } ]    
    Vehicletype.zzheight_unitzca as ZZHeightUnitZCA,
    @Semantics.quantity.unitOfMeasure: 'ZZRangeUnitZCA'
    Vehicletype.zzmax_rangezca as ZZMaxRangeZCA,
    @Consumption.valueHelpDefinition: [ { entity: { name: 'Z10_LengthunitVH', 
                                          element: 'UnitOfMeasure' } } ]  
    Vehicletype.zzrange_unitzca as ZZRangeUnitZCA
    
}
