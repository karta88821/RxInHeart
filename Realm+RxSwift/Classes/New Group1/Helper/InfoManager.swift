import RxSwift
import RxCocoa

let infoManager = InfoManager()

class InfoManager {
    var infoList = Variable<[DeliveryInfo]>([])
    private var currentIdArray = [Int]()
    private var tumpArray: [(Int,Int)]
    private var countList: [Int]
    
    init() {
        tumpArray = []
        countList = []
    }
    
    func getInfoList() -> [DeliveryInfo] {
        return infoList.value
    }
    
    func getValue(at index: Int) -> DeliveryInfo {
        return infoList.value[index]
    }
    
    func getCount() -> Int {
        return infoList.value.count
    }
    
    func insert(with info: DeliveryInfo) {
        infoList.value.append(info)
    }
    
    func remove(at index: Int) {
        infoList.value.remove(at: index)
    }

    func setCurrentIdArray(with currentIdArray:[Int]) {
        self.currentIdArray = currentIdArray
    }
    
    func getTumpList() -> [(Int,Int)] {
        return tumpArray
    }
    
    func getcountList() -> [Int] {
        return countList
    }
    
    func configureCountList() {
        createTumpArray()
        createSelectionCounts()
    }
    
}

private extension InfoManager {
    
    func createTumpArray() {
        let coachArray = infoList.value.map{ $0.deliveryInfoCartItems.map{($0.cartItem.id!,$0.count)}}
        var tumpArray = [(Int,Int)]()
        coachArray.forEach { coach in
            coach.forEach { tumpArray.append($0) }
        }
        
        self.tumpArray = tumpArray
    }
    
    //  [97, 98] [97]
    //  12個 12個 24個
    func createSelectionCounts()  {
        var selectedCounts = [Int]()
        currentIdArray.forEach { id in
            var totalCount = 0 // 97id初始為0個
            tumpArray.forEach { (selectedId, selectedCount) in
                if selectedId == id {
                    totalCount += selectedCount
                }
            }
            selectedCounts.append(totalCount)
        }
        self.countList = selectedCounts
    }
}


