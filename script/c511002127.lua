--グラナドラ
function c511002127.initial_effect(c)
	--recover?
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90925163,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c511002127.condition)
	e1:SetTarget(c511002127.target)
	e1:SetOperation(c511002127.operation)
	c:RegisterEffect(e1)
end
function c511002127.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():IsDefensePos()
end
function c511002127.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
end
function c511002127.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_DEFENSE) then
		Duel.SetLP(p,Duel.GetLP(p)+d)
	end
end