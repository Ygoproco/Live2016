--Ultimate Xyz
--scripted by:urielkama
function c511004124.initial_effect(c)
--activate
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetCost(c511004124.cost)
e1:SetTarget(c511004124.target)
e1:SetOperation(c511004124.operation)
c:RegisterEffect(e1)
end
function c511004124.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c511004124.filter(c,cst)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (not cst or c:GetOverlayCount()~=0)
end
function c511004124.filter2(c,sum)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable() and c:GetAttack()<sum
end
function c511004124.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local chkcost=e:GetLabel()==1 and true or false
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511004124.filter(chkc,chkcost) end
	if chk==0 then
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c511004124.filter,tp,LOCATION_MZONE,0,1,nil,chkcost)
	end
	e:SetLabel(0)
	local tc=Duel.SelectMatchingCard(tp,c511004124.filter,tp,LOCATION_MZONE,0,1,1,nil,chkcost):GetFirst()
	if chkcost then
		tc:RemoveOverlayCard(tp,tc:GetOverlayCount(),tc:GetOverlayCount(),REASON_COST)
		local og=Duel.GetOperatedGroup()
    	local gc=og:GetFirst()
    	local sum=0
    	while gc do
        	local atk=gc:GetAttack()
        	sum=sum+atk
        	gc=og:GetNext()
    	end
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c511004124.filter2(chkc,sum) end
    if chk==0 then return Duel.IsExistingTarget(c511004124.filter2,tp,0,LOCATION_MZONE,1,nil,sum) end
	local g=Duel.SelectTarget(tp,c511004124.filter2,tp,0,LOCATION_MZONE,1,1,nil,sum)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c511004124.operation(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
if tc:IsRelateToEffect(e) then
 	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
 		Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
 		end
 	end
 end