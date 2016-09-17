--Plasma Discharger
function c511000314.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511000314.condition)
	e1:SetCost(c511000314.cost)
	e1:SetOperation(c511000314.operation)
	c:RegisterEffect(e1)
end
function c511000314.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetCurrentPhase()==PHASE_BATTLE
end
function c511000314.ecfilter(c)
	return c:IsType(TYPE_EQUIP) and c:GetEquipTarget()~=nil and c:IsDestructable()
end
function c511000314.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c511000314.ecfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511000314,0))
	local g=Duel.SelectTarget(tp,c511000314.ecfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.Destroy(g:GetFirst(),REASON_COST)
end
function c511000314.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
