--Mystc Eruption
function c511000269.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000269.target)
	e1:SetOperation(c511000269.activate)
	c:RegisterEffect(e1)
end
function c511000269.filter(c,e,tp,tid)
	return c:IsReason(REASON_DESTROY) and c:GetTurnID()==tid and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c511000269.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return c511000269.filter(chkc,e,tp,tid) end
	if chk==0 then return Duel.IsExistingTarget(c511000269.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp,tid) end
	if Duel.IsExistingTarget(c511000269.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,tid) and Duel.IsExistingTarget(c511000269.filter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp,tid) then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,1000)
	elseif Duel.IsExistingTarget(c511000269.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,tid) then
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1000)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
	else
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1000)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	end
end
function c511000269.activate(e,tp,eg,ep,ev,re,r,rp)
	local tid=Duel.GetTurnCount()
	if Duel.IsExistingTarget(c511000269.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,tid) and Duel.IsExistingTarget(c511000269.filter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp,tid) then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		Duel.Damage(tp,1000,REASON_EFFECT)
	else
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	end
end
