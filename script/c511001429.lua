--CNo.102 光堕天使ノーブル・デーモン
function c511001429.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),5,4)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511001429,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c511001429.con)
	e1:SetCost(c511001429.cost)
	e1:SetTarget(c511001429.tg)
	e1:SetOperation(c511001429.op)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c511001429.reptg)
	e2:SetOperation(c511001429.repop)
	c:RegisterEffect(e2)
	--trigger
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511001429,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(511001429)
	e3:SetTarget(c511001429.trtg)
	e3:SetOperation(c511001429.trop)
	c:RegisterEffect(e3)
	if not c511001429.global_check then
		c511001429.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511001429.numchk)
		Duel.RegisterEffect(ge2,0)
	end
end
c511001429.xyz_number=102
function c511001429.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,49678559)
end
function c511001429.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511001429.filter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or not c:IsDisabled())
end
function c511001429.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511001429.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c511001429.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c511001429.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
	end
end
function c511001429.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,49678559) 
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(67173574,0)) then
		local g=e:GetHandler():GetOverlayGroup()
		Duel.SendtoGrave(g,REASON_EFFECT)
		return true
	else return false end
end
function c511001429.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseSingleEvent(e:GetHandler(),511001429,e,r,rp,tp,0)
end
function c511001429.trtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=e:GetHandler():GetAttack()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c511001429.trop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e2)
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local atk=e:GetHandler():GetAttack()
		Duel.Damage(p,atk,REASON_EFFECT)
	end
end
function c511001429.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,67173574)
	Duel.CreateToken(1-tp,67173574)
end
