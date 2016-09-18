--Gearspring Exploder
function c511009015.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(95100633)
	e1:SetCondition(c511009015.condition)
	e1:SetTarget(c511009015.target)
	e1:SetOperation(c511009015.activate)
	c:RegisterEffect(e1)
end
function c511009015.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp) and Duel.GetTurnPlayer()==tp
end
function c511009015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCounter(tp,1,0,0x108)
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*800)
end
function c511009015.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,Duel.GetCounter(tp,1,0,0x108)*800,REASON_EFFECT)
end
