#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
RentOps Python Analytics & AI Advisory Engine
Analyzes SaaS rental management data and generates actionable operational advice,
financial health evaluation, utility anomaly diagnostics, and tenant risk scores.
"""

import sys
import json
import math
from datetime import datetime

# Reconfigure stdout/stderr to UTF-8 for Windows compatibility
if sys.stdout.encoding != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
        sys.stderr.reconfigure(encoding='utf-8')
    except AttributeError:
        pass

def analyze_data(payload):
    rooms = payload.get("rooms", [])
    contracts = payload.get("contracts", [])
    bills = payload.get("bills", [])
    expenses = payload.get("expenses", [])
    readings = payload.get("utility_readings", [])
    maintenance = payload.get("maintenance_requests", [])

    total_rooms = len(rooms)
    occupied_rooms = sum(1 for r in rooms if r.get("status") == "occupied")
    vacant_rooms = sum(1 for r in rooms if r.get("status") == "vacant")
    maintenance_rooms = sum(1 for r in rooms if r.get("status") == "maintenance")
    reserved_rooms = sum(1 for r in rooms if r.get("status") == "reserved")

    occupancy_rate = (occupied_rooms / total_rooms * 100.0) if total_rooms > 0 else 0.0

    # 1. Financial Health Calculation
    total_billed = sum(float(b.get("total_amount", 0)) for b in bills)
    paid_billed = sum(float(b.get("total_amount", 0)) for b in bills if b.get("status") == "paid")
    unpaid_billed = sum(float(b.get("total_amount", 0)) for b in bills if b.get("status") in ["issued", "partially_paid", "overdue"])
    overdue_billed = sum(float(b.get("total_amount", 0)) for b in bills if b.get("status") == "overdue")

    total_expenses = sum(float(e.get("amount", 0)) for e in expenses)
    net_profit = paid_billed - total_expenses
    collection_rate = (paid_billed / total_billed * 100.0) if total_billed > 0 else 100.0

    # Health Scores (0 - 100 scale)
    occupancy_score = min(100.0, occupancy_rate * 1.1)
    collection_score = min(100.0, collection_rate)

    expense_ratio = (total_expenses / paid_billed * 100.0) if paid_billed > 0 else 50.0
    profit_score = max(0.0, min(100.0, 100.0 - expense_ratio))

    overall_health_score = round((occupancy_score * 0.35) + (collection_score * 0.35) + (profit_score * 0.30), 1)

    # 2. Actionable Recommendations Generation
    recommendations = []

    # Recommendation: Vacancy & Pricing Advice
    if vacant_rooms > 0:
        vacant_pct = round((vacant_rooms / total_rooms) * 100, 1) if total_rooms > 0 else 0
        if vacant_pct > 20:
            recommendations.append({
                "type": "warning",
                "category": "pricing",
                "title": f"Tỷ lệ phòng trống cao ({vacant_pct}%)",
                "message": f"Hiện có {vacant_rooms} phòng trống. Đề xuất giảm nhẹ giá thuê 3-5% hoặc hỗ trợ giảm 50% cọc tháng đầu để tăng nhanh tỷ lệ lấp đầy.",
                "impact": "Tăng doanh thu ước tính +15-20%"
            })
        else:
            recommendations.append({
                "type": "info",
                "category": "pricing",
                "title": f"Tỷ lệ lấp đầy ở mức tốt ({round(occupancy_rate, 1)}%)",
                "message": f"Duy trì mức giá hiện tại cho {vacant_rooms} phòng còn trống. Có thể xem xét tăng giá 5% cho các hợp đồng gia hạn sắp tới.",
                "impact": "Tối ưu hóa lợi nhuận ròng"
            })
    else:
        recommendations.append({
            "type": "success",
            "category": "pricing",
            "title": "Tỷ lệ lấp đầy đạt 100%",
            "message": "Toàn bộ các phòng đều đã được thuê. Đề xuất tăng nhẹ 5-8% giá niêm yết cho các hợp đồng ký mới tiếp theo.",
            "impact": "Tăng tối đa doanh thu phòng"
        })

    # Recommendation: Debt Collection & Overdue Bills
    overdue_count = sum(1 for b in bills if b.get("status") == "overdue")
    if overdue_count > 0:
        recommendations.append({
            "type": "danger",
            "category": "finance",
            "title": f"Có {overdue_count} hóa đơn quá hạn chưa thu",
            "message": f"Tổng dư nợ quá hạn: {overdue_billed:,.0f}đ. Đề xuất gửi thông báo tự động nhắc nợ Zalo/SMS hoặc gọi điện nhắc nhở trực tiếp.",
            "impact": "Cải thiện dòng tiền ngay lập tức"
        })
    else:
        recommendations.append({
            "type": "success",
            "category": "finance",
            "title": "Quản lý dòng tiền xuất sắc",
            "message": "Không có hóa đơn nào bị quá hạn. Tỷ lệ thu hồi nợ đạt mức cao.",
            "impact": "Dòng tiền ổn định"
        })

    # Utility Anomaly Diagnostic
    abnormal_readings = [r for r in readings if r.get("anomaly_detected") or r.get("is_abnormal")]
    if abnormal_readings:
        count_ab = len(abnormal_readings)
        sample_room = abnormal_readings[0].get("room_number", "N/A")
        recommendations.append({
            "type": "danger",
            "category": "utility",
            "title": f"Phát hiện {count_ab} bất thường điện/nước",
            "message": f"Phòng {sample_room} có lượng tiêu thụ tăng >50% so với tháng trước. Kiểm tra ngay nguy cơ rò rỉ đường ống nước hoặc chập điện thiết bị.",
            "impact": "Tránh thất thoát tài sản & chi phí phạt"
        })

    # Maintenance Expense Warning
    high_cost_maintenances = [m for m in maintenance if float(m.get("cost", 0)) >= 300000]
    if high_cost_maintenances:
        recommendations.append({
            "type": "warning",
            "category": "maintenance",
            "title": f"Có {len(high_cost_maintenances)} sự cố sửa chữa chi phí cao",
            "message": "Một số thiết bị thường xuyên hỏng hóc gây tốn kém chi phí. Đề xuất lập lịch bảo trì định kỳ 6 tháng/lần thay vì sửa lẻ.",
            "impact": "Tiết kiệm 20% chi phí sửa chữa dài hạn"
        })

    # Executive Summary Text
    summary_text = (
        f"Hệ thống RentOps hiện vận hành {total_rooms} phòng với tỷ lệ lấp đầy {occupancy_rate:.1f}%. "
        f"Tổng doanh thu thu được đạt {paid_billed:,.0f} VNĐ với lợi nhuận ròng ước tính {net_profit:,.0f} VNĐ. "
        f"Chỉ số sức khỏe tổng thể đạt {overall_health_score}/100. "
    )
    if overdue_billed > 0:
        summary_text += f"Cần tập trung xử lý {overdue_count} hóa đơn quá hạn với tổng nợ {overdue_billed:,.0f} VNĐ."

    return {
        "status": "success",
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "overall_health_score": overall_health_score,
        "scores": {
            "occupancy_score": round(occupancy_score, 1),
            "collection_score": round(collection_score, 1),
            "profit_score": round(profit_score, 1)
        },
        "kpis": {
            "total_rooms": total_rooms,
            "occupied_rooms": occupied_rooms,
            "vacant_rooms": vacant_rooms,
            "occupancy_rate": round(occupancy_rate, 1),
            "total_billed": total_billed,
            "paid_billed": paid_billed,
            "unpaid_billed": unpaid_billed,
            "overdue_billed": overdue_billed,
            "total_expenses": total_expenses,
            "net_profit": net_profit,
            "collection_rate": round(collection_rate, 1)
        },
        "recommendations": recommendations,
        "executive_summary": summary_text
    }

if __name__ == "__main__":
    try:
        if len(sys.argv) > 1 and sys.argv[1].endswith(".json"):
            with open(sys.argv[1], "r", encoding="utf-8") as f:
                input_data = json.load(f)
        else:
            raw_input = sys.stdin.read()
            input_data = json.loads(raw_input) if raw_input.strip() else {}
        
        result = analyze_data(input_data)
        print(json.dumps(result, ensure_ascii=False, indent=2))
    except Exception as e:
        error_res = {
            "status": "error",
            "message": str(e),
            "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        }
        print(json.dumps(error_res, ensure_ascii=False))
