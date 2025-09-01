import 'package:caterease/features/customer_order_list/domain/entities/bill_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class OrderDetailsEntity extends Equatable {
  final OrderEntity order;
  final AddressEntity address;
  final List<PackageEntity> packages;
  final BillEntity? bill;

  const OrderDetailsEntity({
    required this.order,
    required this.address,
    required this.packages,
    this.bill,
  });

  @override
  List<Object?> get props => [
        order,
        address,
        packages,
        bill,
      ];
}

class OrderEntity extends Equatable {
  final int orderId;
  final String status;
  final bool isApproved;
  final String? approvalDeadline;
  final String? notes;
  final String deliveryTime;
  final String totalPrice;
  final String? qrCode;
  const OrderEntity(
      {required this.approvalDeadline,
      required this.deliveryTime,
      required this.isApproved,
      required this.notes,
      required this.orderId,
      required this.qrCode,
      required this.status,
      required this.totalPrice});
  @override
  List<Object?> get props => [
        approvalDeadline,
        deliveryTime,
        isApproved,
        notes,
        orderId,
        qrCode,
        status,
        totalPrice
      ];
}

class AddressEntity extends Equatable {
  final String street;
  final String building;
  final String floor;
  final String apartment;
  final String city;

  const AddressEntity({
    required this.street,
    required this.building,
    required this.floor,
    required this.apartment,
    required this.city,
  });

  @override
  List<Object?> get props => [street, building, floor, apartment, city];
}

class PackageEntity extends Equatable {
  final int orderDetailsId;
  final int packageId;
  final String name;
  final int branchId;
  final String restaurantName;
  final String description;
  final String photo;
  final String basePrice;
  final int quantity;
  final int servesCount;
  final int extraPersons;
  final String pricePerExtraPerson;
  final String extraPersonsCost;
  final int totalPersons;
  final bool prepaymentRequired;
  final String prepaymentPercentage;
  final String prepaymentAmount;
  final String cancellationPolicy;
  final String occasionType;
  final List<ItemEntity> items;
  final List<ServiceEntity> services;
  final List<ExtraEntity> extras;
  final String finalTotal;

  const PackageEntity({
    required this.orderDetailsId,
    required this.packageId,
    required this.name,
    required this.branchId,
    required this.restaurantName,
    required this.description,
    required this.photo,
    required this.basePrice,
    required this.quantity,
    required this.servesCount,
    required this.extraPersons,
    required this.pricePerExtraPerson,
    required this.extraPersonsCost,
    required this.totalPersons,
    required this.prepaymentRequired,
    required this.prepaymentPercentage,
    required this.prepaymentAmount,
    required this.cancellationPolicy,
    required this.occasionType,
    required this.items,
    required this.services,
    required this.extras,
    required this.finalTotal,
  });

  @override
  List<Object?> get props => [
        orderDetailsId,
        packageId,
        name,
        branchId,
        restaurantName,
        description,
        photo,
        basePrice,
        quantity,
        servesCount,
        extraPersons,
        pricePerExtraPerson,
        extraPersonsCost,
        totalPersons,
        prepaymentRequired,
        prepaymentPercentage,
        prepaymentAmount,
        cancellationPolicy,
        occasionType,
        items,
        services,
        extras,
        finalTotal,
      ];
}

class ItemEntity extends Equatable {
  final int foodItemId;
  final String foodItemName;
  final int quantity;

  const ItemEntity({
    required this.foodItemId,
    required this.foodItemName,
    required this.quantity,
  });

  @override
  List<Object?> get props => [foodItemId, foodItemName, quantity];
}

class ServiceEntity extends Equatable {
  final String name;
  final String customPrice;

  const ServiceEntity({
    required this.name,
    required this.customPrice,
  });

  @override
  List<Object?> get props => [name, customPrice];
}

class ExtraEntity extends Equatable {
  // Assuming extras can be empty for now based on the JSON example
  // If there's a structure for extras, it should be defined here.
  @override
  List<Object?> get props => [];
}


